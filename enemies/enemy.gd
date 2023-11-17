class_name Enemy
extends CharacterBody2D

@export var speed := 20.0
@export var health := 10.0
@export var exp := 1.0
@export var knockback := Vector2.ZERO
@export var knockback_recovery := 3.5
@export var death_anim := preload("res://enemies/explosion.tscn")

var exp_gem := preload("res://loot/exp_gem.tscn")

@onready var character_sprite: AnimatedSprite2D = %CharacterSprite
@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var loot_node := get_tree().root.get_node("World/Loot") as Node2D
@onready var audio_hit = $AudioHit


func _ready() -> void:
	character_sprite.play("walk")


func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * speed
	velocity += knockback
	if direction.x > 0.1:
		character_sprite.flip_h = true
	elif direction.x < -0.1:
		character_sprite.flip_h = false
	move_and_slide()


func die() -> void:
	var new_death_anim := death_anim.instantiate() as AnimatedSprite2D
	new_death_anim.global_position = global_position
	get_parent().call_deferred("add_child", new_death_anim)
	var new_gem := exp_gem.instantiate() as ExpGem
	loot_node.call_deferred("add_child", new_gem)
	new_gem.global_position = global_position
	new_gem.exp = exp
	queue_free()


func _on_hurt_box_hurt(damage: float, angle: Vector2, knockback_strength: float) -> void:
	knockback = angle * knockback_strength
	health -= damage
	if health <= 0:
		die()
	else:
		audio_hit.play()
