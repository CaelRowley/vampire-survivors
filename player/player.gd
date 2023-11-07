class_name Player
extends CharacterBody2D

@export var speed := 100.0
@export var health := 100.0

var last_movement_dir := Vector2.UP

var ice_spear := preload("res://player/attacks/ice_spear.tscn")
var ice_spear_ammo := 0
var ice_spear_base_ammo := 0
var ice_spear_attack_speed := 1.5
var ice_spear_level := 1

var tornado := preload("res://player/attacks/tornado.tscn")
var tornado_ammo := 0
var tornado_base_ammo := 0
var tornado_attack_speed := 1.5
var tornado_level := 1

var javelin := preload("res://player/attacks/javelin.tscn")
var javelin_ammo := 3
var javelin_level := 1

var enemies_in_range: Array[Enemy] = []

@onready var ice_spear_timer: Timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer: Timer = ice_spear_timer.get_node("AttackTimer")
@onready var tornado_timer: Timer = $Attack/TornadoTimer
@onready var tornado_attack_timer: Timer = tornado_timer.get_node("AttackTimer")
@onready var javelins = $Attack/Javelins

@onready var character_sprite: AnimatedSprite2D = %CharacterSprite


func _ready():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attack_speed
		if tornado_timer.is_stopped():
			tornado_timer.start()
	if javelin_level > 0:
		var javelin_count := javelins.get_child_count()
		var spawn_count := javelin_ammo - javelin_count
		while  spawn_count > 0:
			var new_javelin := javelin.instantiate() as Node2D
			javelins.add_child(new_javelin)
			new_javelin.global_position = global_position
			spawn_count -= 1


func _physics_process(_delta: float):
	var x_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input := Input.get_action_strength("down") - Input.get_action_strength("up")
	var movement_dir := Vector2(x_input, y_input)
	
	if movement_dir != Vector2.ZERO:
		last_movement_dir = movement_dir
		if !character_sprite.is_playing():
			character_sprite.set_frame(1)
			character_sprite.play()
	else:
		if character_sprite.is_playing():
			character_sprite.stop()
	
	if character_sprite.is_playing():
		character_sprite.flip_h = movement_dir.x > 0
		
	velocity = movement_dir.normalized() * speed
	move_and_slide()


func get_random_target() -> Vector2:
	if enemies_in_range.is_empty():
		return Vector2.ZERO
	return enemies_in_range.pick_random().global_position


func _on_hurt_box_hurt(damage: float, _angle: Vector2, _knockback_strength: float):
	health -= damage
	if health <= 0:
		print("dead")


func _on_enemy_detection_body_entered(body: Enemy):
	if !enemies_in_range.has(body):
		enemies_in_range.push_back(body)


func _on_enemy_detection_body_exited(body: Enemy):
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)


func _on_ice_spear_timer_timeout():
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_attack_timer.start()


func _on_ice_spear_attack_timer_timeout():
	if ice_spear_ammo > 0:
		var new_ice_spear := ice_spear.instantiate() as Node2D
		new_ice_spear.position = position
		new_ice_spear.target_pos = get_random_target()
		new_ice_spear.level = ice_spear_level
		add_child(new_ice_spear)
		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
			ice_spear_attack_timer.stop()


func _on_tornado_timer_timeout():
	tornado_ammo += tornado_base_ammo
	tornado_attack_timer.start()


func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var new_tornado := tornado.instantiate() as Node2D
		new_tornado.position = position
		new_tornado.target_pos = get_random_target()
		new_tornado.last_movement_dir = last_movement_dir
		new_tornado.level = tornado_level
		add_child(new_tornado)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
			tornado_attack_timer.stop()
