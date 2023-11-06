extends Node2D

var level := 1
var health := 1
var speed := 150.0
var attack_size := 1.0

var last_movement_dir := Vector2.ZERO
var target_pos := Vector2.ZERO
var angle := Vector2.ZERO
var angle_less := Vector2.ZERO
var angle_more := Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var hit_box := $HitBox as HitBox


func _ready():
	angle = global_position.direction_to(target_pos)
	hit_box.angle = angle
	
	match level:
		1: 
			health = 9999
			speed = 100.0
			attack_size = 1.0

	var move_to_less := Vector2.ZERO
	var move_to_more := Vector2.ZERO
	
	# To improve, remove hard coded directions and replace with random rotation of last_movement_dir
	# Or make the path a sine wave
	match last_movement_dir:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1, -0.25), last_movement_dir.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25, 1), last_movement_dir.y)*500
		Vector2.LEFT, Vector2.RIGHT:
			move_to_less = global_position + Vector2(last_movement_dir.x, randf_range(-1, -0.25))*500
			move_to_more = global_position + Vector2(last_movement_dir.x, randf_range(0.25, 1))*500
		Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1):
			move_to_less = global_position + Vector2(last_movement_dir.x, last_movement_dir.y * randf_range(0, 0.75))*500
			move_to_more = global_position + Vector2(last_movement_dir.x * randf_range(0, 0.75),  last_movement_dir.y)*500
	
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	
	
	var tween := create_tween()
	tween.set_loops()
	if randi_range(0, 1):
		angle = angle_less
		tween.tween_property(self, "angle", angle_more, 1.0)
		tween.tween_property(self, "angle", angle_less, 1.0)
	else:
		angle = angle_more
		tween.tween_property(self, "angle", angle_less, 1.0)
		tween.tween_property(self, "angle", angle_more, 1.0)
	
	var scale_tween := create_tween().set_parallel(true)
	scale_tween.tween_property(self, "scale", Vector2.ONE*attack_size, 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed := speed
	speed = speed/5.0
	scale_tween.tween_property(self, "speed", final_speed, 6.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	scale_tween.play()


func _physics_process(delta: float):
	position += angle * speed * delta


func die():
	hit_box.die()
	queue_free()


func _on_timer_timeout():
	die()
