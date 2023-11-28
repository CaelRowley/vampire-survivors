class_name CustomButton
extends Button

@export var handle_press = Callable(func handle_press() -> void: print("handle_press"))


func on_pressed() -> void:
	$AudioClick.play()
	await $AudioClick.finished
	handle_press.call()


func _on_mouse_entered():
	$AudioHover.play()


func _on_pressed():
	on_pressed()
