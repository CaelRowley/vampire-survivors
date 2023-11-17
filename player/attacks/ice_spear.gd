extends Node2D

var level := 1
var health := 1
var speed := 100.0
var attack_size := 1.0

var target_pos := Vector2.ZERO
var angle := Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var hit_box := $HitBox as HitBox


func _ready():
	angle = global_position.direction_to(target_pos)
	rotation = angle.angle() + deg_to_rad(135)
	hit_box.angle = angle
	
	match level:
		1:
			health = 1
			speed = 100
			hit_box.damage = 5
			hit_box.knockback_strength = 100
			attack_size = player.spell_size
		2:
			health = 1
			speed = 100
			hit_box.damage = 5
			hit_box.knockback_strength = 100
			attack_size = player.spell_size
		3:
			health = 2
			speed = 100
			hit_box.damage = 8
			hit_box.knockback_strength = 100
			attack_size = player.spell_size
		4:
			health = 2
			speed = 100
			hit_box.damage = 8
			hit_box.knockback_strength = 100
			attack_size = player.spell_size
			
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE*attack_size, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()


func _physics_process(delta: float):
	position += angle * speed * delta


func die():
	hit_box.die()
	queue_free()


func _on_timer_timeout():
	die()


func _on_hit_box_hit(_hit_box: HitBox, _hurt_box: HurtBox):
	health -= 1
	if health <= 0:
		die()
