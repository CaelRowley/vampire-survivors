class_name CustomButton
extends Button

@export var handle_press = Callable(func handle_press() -> void: pass)

@onready var audio_hover := $AudioHover as AudioStreamPlayer
@onready var audio_click := $AudioClick as AudioStreamPlayer


func on_pressed() -> void:
	audio_click.play()
	await audio_click.finished
	handle_press.call()


func _on_mouse_entered():
	audio_hover.play()


func _on_pressed():
	on_pressed()
