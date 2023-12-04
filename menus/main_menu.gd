extends Control

var level := "res://world/world.tscn"

@onready var btn_play := $BtnPlay as CustomButton
@onready var btn_quit := $BtnQuit as CustomButton
@onready var btn_host := $BtnHost as CustomButton
@onready var btn_join := $BtnJoin as CustomButton


func _ready() -> void:
	btn_play.handle_press = func handle_press() -> void: get_tree().change_scene_to_file(level)
	btn_quit.handle_press = func handle_press() -> void: get_tree().quit()
	btn_host.handle_press = _handle_host
	btn_join.handle_press = _handle_join


func _handle_host() -> void:
	GameSession.is_online = true
	GameSession.is_host = true
	get_tree().change_scene_to_file(level)


func _handle_join() -> void:
	GameSession.is_online = true
	GameSession.is_host = false
	get_tree().change_scene_to_file(level)
