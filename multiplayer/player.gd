extends CharacterBody2D

@export var speed := 100.0
var last_movement_dir := Vector2.UP


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		var x_input := Input.get_action_strength("right") - Input.get_action_strength("left")
		var y_input := Input.get_action_strength("down") - Input.get_action_strength("up")
		var movement_dir := Vector2(x_input, y_input)
		
		if movement_dir != Vector2.ZERO:
			last_movement_dir = movement_dir
			
		velocity = movement_dir.normalized() * (speed)
	move_and_slide()
