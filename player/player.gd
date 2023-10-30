extends CharacterBody2D

@export var speed := 100.0
@export var health := 100.0

@onready var character_sprite: AnimatedSprite2D = %CharacterSprite


func _physics_process(delta: float):
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


func _on_hurt_box_hurt(damage: float):
	health -= damage
	print(health)
