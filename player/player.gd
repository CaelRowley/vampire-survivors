extends CharacterBody2D

var speed := 100.0


func _physics_process(delta: float):
	var movement_input := Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))
	velocity = movement_input.normalized() * speed
	move_and_slide()

