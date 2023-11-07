extends Node2D

var level := 1
var health := 1
var speed := 100.0
var attack_size := 1.0
var attack_speed := 4.0

var base_ammo := 3
var ammo := base_ammo

var target_dir := Vector2.ZERO
var random_direction := Vector2((randf()*2) -1, (randf()*2) -1).normalized()

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var hit_box := $HitBox as HitBox

@onready var attack_timer := $AttackTimer as Timer
@onready var recharge_timer := $RechargeTimer as Timer

@onready var sprite_new := $SpriteNew as Sprite2D
@onready var sprite_attack := $SpriteAttack as Sprite2D
@onready var audio_stream_player := $AudioStreamPlayer as AudioStreamPlayer

@onready var collision := $HitBox/CollisionShape2D as CollisionShape2D


func _ready():
	var dir_to_player := global_position.direction_to(player.global_position)
	rotation = dir_to_player.angle() + deg_to_rad(135)
	hit_box.angle = dir_to_player
	
	match level:
		1: 
			health = 9999
			speed = 200.0
			attack_size = 1.0

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE*attack_size, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	attack_timer.wait_time = attack_speed


func _physics_process(delta: float):
	if target_dir:
		position += target_dir * speed * delta
	else:
		var reset_pos = player.global_position + (random_direction * 50.0)
		var return_speed := maxf(global_position.distance_to(reset_pos), 20.0)
		position += global_position.direction_to(reset_pos) * return_speed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)


func attack():
	ammo -= 1
	audio_stream_player.play()
	target_dir = global_position.direction_to(player.get_random_target())
	set_is_attacking(true)
	recharge_timer.start()
	var tween := create_tween()
	var target_rotation := target_dir.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", target_rotation, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()


func set_is_attacking(is_enabled := true):
	sprite_new.visible = !is_enabled
	sprite_attack.visible = is_enabled
	collision.call_deferred("set", "disabled", !is_enabled)


func _on_attack_timer_timeout():
	ammo = base_ammo
	attack_timer.stop()
	attack()


func _on_recharge_timer_timeout():
	if ammo > 0:
		attack()
	else:
		set_is_attacking(false)
		random_direction = Vector2((randf()*2) -1, (randf()*2) -1).normalized()
		target_dir = Vector2.ZERO
		recharge_timer.stop()
		attack_timer.start()
