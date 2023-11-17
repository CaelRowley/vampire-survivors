extends ColorRect

signal upgrade_selected(upgrade: String)

var item := "Food" 

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var label_name := $LabelName as Label
@onready var label_description := $LabelDescription as Label
@onready var label_level := $LabelLevel as Label
@onready var icon := $ColorRect/Icon as TextureRect


func _ready():
	upgrade_selected.connect(Callable(player, "upgrade_character"))
	
	label_name.text = UpgradeDb.UPGRADES[item]["DisplayName"]
	label_description.text = UpgradeDb.UPGRADES[item]["Details"]
	label_level.text = UpgradeDb.UPGRADES[item]["Level"]
	icon.texture = load(UpgradeDb.UPGRADES[item]["Icon"])


func _on_mouse_entered():
	print("_on_mouse_entered")


func _on_mouse_exited():
	print("_on_mouse_exited")


func _on_gui_input(event):
	if event.is_action("select"):
		upgrade_selected.emit(item)
