extends Node2D

@onready var audio_music = $AudioMusic


func _on_player_player_died():
	audio_music.stop()

