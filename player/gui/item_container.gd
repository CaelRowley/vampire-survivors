extends TextureRect

var upgrade := "Javelin4"


func _ready():
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade].Icon)
