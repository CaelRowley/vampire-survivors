extends Node2D

@onready var audio_music = $AudioMusic

@export var player_scene: PackedScene

var peer = ENetMultiplayerPeer.new()


func _ready():
	if GameSession.is_online:
		if GameSession.is_host:
			peer.create_server(GameSession.peer_id)
			multiplayer.multiplayer_peer = peer
			multiplayer.peer_connected.connect(_add_player)
			_add_player()
		else:
			peer.create_client("localhost", GameSession.peer_id)
			multiplayer.multiplayer_peer = peer
	else:
		_add_player()


func _on_player_player_died():
	audio_music.stop()


# peer ID 1 is the server
func _add_player(id = 1) -> void:
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
