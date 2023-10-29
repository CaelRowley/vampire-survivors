extends CharacterBody2D


@export var speed := 20.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float):
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
