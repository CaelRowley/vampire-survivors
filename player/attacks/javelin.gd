extends Node2D

var level := 1
var health := 1
var speed := 100.0
var attack_size := 1.0
var attack_speed := 4.0

var paths := 3

var target_pos := Vector2.ZERO
var target_list := []

var angle := Vector2.ZERO
var reset_pos := Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var hit_box := $HitBox as HitBox


@onready var attack_timer := $AttackTimer as Timer
@onready var change_direction_timer := $ChangeDirectionTimer as Timer
@onready var reset_postimer := $ResetPostimer as Timer

@onready var sprite_new := $SpriteNew as Sprite2D
@onready var sprite_attack := $SpriteAttack as Sprite2D
@onready var audio_stream_player := $AudioStreamPlayer as AudioStreamPlayer

@onready var collision := $HitBox/CollisionShape2D as CollisionShape2D

func _ready():
	angle = global_position.direction_to(target_pos)
	rotation = angle.angle() + deg_to_rad(135)
	hit_box.angle = angle
	
	match level:
		1: 
			health = 9999
			speed = 200.0
			attack_size = 1.0

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE*attack_size, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	attack_timer.wait_time = attack_speed
	
	_on_reset_postimer_timeout()


func _physics_process(delta: float):
	if !target_list.is_empty():
		position += angle * speed * delta
	else:
		var player_angle := global_position.direction_to(reset_pos)
		var distance_dif := global_position - player.global_position
		var return_speed := 200
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 1000
		position += player_angle * return_speed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)


func die():
	hit_box.die()
	queue_free()


func _on_timer_timeout():
	die()


func _on_hit_box_hit(_hit_box: HitBox, _hurt_box: HurtBox):
	health -= 1
	if health <= 0:
		die()


func add_paths():
	audio_stream_player.play()
	target_list.clear()
	var counter := 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_list.append(new_path)
		counter += 1
		enable_attack(true)
	target_pos = target_list[0]
	process_path()


func process_path():
	angle = global_position.direction_to(target_pos)
	change_direction_timer.start()
	var tween := create_tween()
	var new_rot_deg := angle.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", new_rot_deg, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()


func _on_attack_timer_timeout():
	add_paths()


func enable_attack(is_enabled := true):
	sprite_new.visible = !is_enabled
	sprite_attack.visible = is_enabled
	collision.call_deferred("set", "disabled", !is_enabled)


func _on_change_direction_timer_timeout():
	if !target_list.is_empty():
		target_list.remove_at(0)
		if !target_list.is_empty():
			target_pos = target_list[0]
			process_path()
			audio_stream_player.play()
		else:
			enable_attack(false)
	else:
		change_direction_timer.stop()
		attack_timer.start()
		enable_attack(false)


func _on_reset_postimer_timeout():
	var choose_direction := randi() % 4 # 0, 1 ,2 ,3
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
