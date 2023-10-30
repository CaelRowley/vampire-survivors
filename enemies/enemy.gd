extends CharacterBody2D

@export var speed := 20.0
@export var health := 10.0

@onready var character_sprite: AnimatedSprite2D = %CharacterSprite
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func _ready():
	character_sprite.play("walk")


func _physics_process(_delta: float):
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	if direction.x > 0.1:
		character_sprite.flip_h = true
	elif direction.x < -0.1:
		character_sprite.flip_h = false
	
	move_and_slide()


func _on_hurt_box_hurt(damage: float):
	health -= damage
	if health <= 0:
		queue_free()
