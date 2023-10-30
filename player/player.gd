class_name Player
extends CharacterBody2D

@export var speed := 100.0
@export var health := 100.0

var ice_spear := preload("res://player/attacks/ice_spear.tscn")
var ice_spear_ammo := 0
var ice_spear_base_ammo := 5
var ice_spear_attack_speed := 1.5
var ice_spear_level := 1

var enemies_in_range: Array[Enemy] = []

@onready var ice_spear_timer: Timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer: Timer = ice_spear_timer.get_node("AttackTimer")
@onready var character_sprite: AnimatedSprite2D = %CharacterSprite


func _ready():
	attack()


func _physics_process(_delta: float):
	var x_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input := Input.get_action_strength("down") - Input.get_action_strength("up")
	var movement_input := Vector2(x_input, y_input)
	
	if movement_input != Vector2.ZERO:
		if !character_sprite.is_playing():
			character_sprite.set_frame(1)
			character_sprite.play()
	else:
		if character_sprite.is_playing():
			character_sprite.stop()
	
	if character_sprite.is_playing():
		character_sprite.flip_h = movement_input.x > 0
		
	velocity = movement_input.normalized() * speed
	move_and_slide()


func attack():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()


func get_random_target() -> Vector2:
	if enemies_in_range.is_empty():
		return Vector2.ZERO
	return enemies_in_range.pick_random().global_position


func _on_hurt_box_hurt(damage: float):
	health -= damage
	if health <= 0:
		queue_free()


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
		else:
			ice_spear_attack_timer.stop()


func _on_enemy_detection_body_entered(body: Enemy):
	if !enemies_in_range.has(body):
		enemies_in_range.push_back(body)


func _on_enemy_detection_body_exited(body: Enemy):
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)
