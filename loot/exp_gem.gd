class_name ExpGem
extends Area2D

@export var exp := 1
@export var sprite_green := preload("res://textures/items/gems/gem_green.png")
@export var sprite_blue := preload("res://textures/items/gems/gem_blue.png")
@export var sprite_red := preload("res://textures/items/gems/gem_red.png")
@export var speed := 5.0

var target: Node2D
var target_pos: Vector2
var current_speed := -1.0

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var audio_stream_player = $AudioStreamPlayer


func _ready() -> void:
	if exp < 5:
		sprite_2d.texture = sprite_green
	elif exp < 25:
		sprite_2d.texture = sprite_blue
	else:
		sprite_2d.texture = sprite_red


func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = global_position.move_toward(target.global_position, current_speed)
		current_speed += speed*delta


func collect() -> int:
	audio_stream_player.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	return exp


func _on_audio_stream_player_finished() -> void:
	queue_free()
