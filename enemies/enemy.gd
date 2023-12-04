class_name Enemy
extends CharacterBody2D

@export var speed := 20.0
@export var health := 10.0
@export var damage := 1.0
@export var experience := 1
@export var knockback := Vector2.ZERO
@export var knockback_recovery := 3.5
@export var death_anim := preload("res://enemies/explosion.tscn")

var exp_gem := preload("res://loot/exp_gem.tscn")

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var loot_node := get_tree().root.get_node("World/Loot") as Node2D

@onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D
@onready var character_sprite := %CharacterSprite as AnimatedSprite2D
@onready var hit_box := $HitBox as HitBox
@onready var hurt_box := $HurtBox as HurtBox
@onready var audio_hit := $AudioHit as AudioStreamPlayer2D


func _ready() -> void:
	character_sprite.play("walk")
	hit_box.damage = damage
	_optimise_off_screen_perf(!$VisibleOnScreenNotifier2D.is_on_screen())


func _physics_process(_delta: float) -> void:
	return
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
	new_gem.experience = experience
	queue_free()


func _handle_on_screen() -> void: 
	collision_shape_2d.process_mode = Node.PROCESS_MODE_INHERIT
	character_sprite.process_mode = Node.PROCESS_MODE_INHERIT
	hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	audio_hit.process_mode = Node.PROCESS_MODE_INHERIT


func _optimise_off_screen_perf(should_optimise := true) -> void:
	var mode := Node.PROCESS_MODE_DISABLED if should_optimise else Node.PROCESS_MODE_INHERIT
	collision_shape_2d.process_mode = mode
	character_sprite.process_mode = mode
	hit_box.process_mode = mode
	audio_hit.process_mode = mode


func _on_hurt_box_hurt(damage_taken: float, angle: Vector2, knockback_strength: float) -> void:
	knockback = angle * knockback_strength
	health -= damage_taken
	if health <= 0:
		die()
	else:
		audio_hit.play()


func _on_visible_on_screen_notifier_2d_screen_entered():
	_optimise_off_screen_perf(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	_optimise_off_screen_perf()
