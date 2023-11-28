extends Control


var level := "res://world/world.tscn"

@onready var btn_play := $BtnPlay as CustomButton
@onready var btn_quit := $BtnQuit as CustomButton



func _ready() -> void:
	btn_play.handle_press = func handle_press() -> void: get_tree().change_scene_to_file(level)
	btn_quit.handle_press = func handle_press() -> void: get_tree().quit()
