extends ColorRect

signal upgrade_selected(upgrade)

var item = null

@onready var player := get_tree().get_first_node_in_group("player") as Player


func _ready():
	upgrade_selected.connect(Callable(player, "upgrade_character"))


func _on_mouse_entered():
	print("_on_mouse_entered")


func _on_mouse_exited():
	print("_on_mouse_exited")


func _on_gui_input(event):
	if event.is_action("select"):
		upgrade_selected.emit(item)
