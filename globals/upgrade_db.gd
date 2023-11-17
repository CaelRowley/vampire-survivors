extends Node

const UPGRADES_PATH = "res://textures/items/Upgrades/"
const WEAPONS_PATH = "res://textures/items/Weapons/"

const UPGRADES = {
	"IceSpear1": {
		"Icon": WEAPONS_PATH + "ice_spear.png",
		"DisplayName": "Ice Spear",
		"Details": "A spear of ice is thrown at a random enemy",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Weapon"
	},
	"IceSpear2": {
		"Icon": WEAPONS_PATH + "ice_spear.png",
		"DisplayName": "Ice Spear",
		"Details": "An additional spear of ice is thrown",
		"Level": "Level: 2",
		"Prerequisites": ["IceSpear1"],
		"Type": "Weapon"
	},
	"IceSpear3": {
		"Icon": WEAPONS_PATH + "ice_spear.png",
		"DisplayName": "Ice Spear",
		"Details": "Ice Spears now pass through another enemy and do + 3 damage",
		"Level": "Level: 3",
		"Prerequisites": ["IceSpear2"],
		"Type": "Weapon"
	},
	"IceSpear4": {
		"Icon": WEAPONS_PATH + "ice_spear.png",
		"DisplayName": "Ice Spear",
		"Details": "An additional 2 Ice Spears are thrown",
		"Level": "Level: 3",
		"Prerequisites": ["IceSpear3"],
		"Type": "Weapon"
	},
	"Javelin1": {
		"Icon": WEAPONS_PATH + "javelin_3_new_attack.png",
		"DisplayName": "Javelin",
		"Details": "A magical javelin will follow you attacking enemies in a straight line",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Weapon"
	},
	"Javelin2": {
		"Icon": WEAPONS_PATH + "javelin_3_new_attack.png",
		"DisplayName": "Javelin",
		"Details": "The javelin will now attack an additional enemy per attack",
		"Level": "Level: 2",
		"Prerequisites": ["Javelin1"],
		"Type": "Weapon"
	},
	"Javelin3": {
		"Icon": WEAPONS_PATH + "javelin_3_new_attack.png",
		"DisplayName": "Javelin",
		"Details": "The javelin will attack another additional enemy per attack",
		"Level": "Level: 3",
		"Prerequisites": ["Javelin2"],
		"Type": "Weapon"
	},
	"Javelin4": {
		"Icon": WEAPONS_PATH + "javelin_3_new_attack.png",
		"DisplayName": "Javelin",
		"Details": "The javelin now does + 5 damage per attack and causes 20% additional knockback",
		"Level": "Level: 4",
		"Prerequisites": ["Javelin3"],
		"Type": "Weapon"
	},
	"Tornado1": {
		"Icon": WEAPONS_PATH + "tornado.png",
		"DisplayName": "Tornado",
		"Details": "A tornado is created and random heads somewhere in the players direction",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Weapon"
	},
	"Tornado2": {
		"Icon": WEAPONS_PATH + "tornado.png",
		"DisplayName": "Tornado",
		"Details": "An additional Tornado is created",
		"Level": "Level: 2",
		"Prerequisites": ["Tornado1"],
		"Type": "Weapon"
	},
	"Tornado3": {
		"Icon": WEAPONS_PATH + "tornado.png",
		"DisplayName": "Tornado",
		"Details": "The Tornado cooldown is reduced by 0.5 seconds",
		"Level": "Level: 3",
		"Prerequisites": ["Tornado2"],
		"Type": "Weapon"
	},
	"Tornado4": {
		"Icon": WEAPONS_PATH + "tornado.png",
		"DisplayName": "Tornado",
		"Details": "An additional tornado is created and the knockback is increased by 25%",
		"Level": "Level: 4",
		"Prerequisites": ["Tornado3"],
		"Type": "Weapon"
	},
	"Armor1": {
		"Icon": UPGRADES_PATH + "helmet_1.png",
		"DisplayName": "Armor",
		"Details": "Reduces Damage By 1 point",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Upgrade"
	},
	"Armor2": {
		"Icon": UPGRADES_PATH + "helmet_1.png",
		"DisplayName": "Armor",
		"Details": "Reduces Damage By an additional 1 point",
		"Level": "Level: 2",
		"Prerequisites": ["Armor1"],
		"Type": "Upgrade"
	},
	"Armor3": {
		"Icon": UPGRADES_PATH + "helmet_1.png",
		"DisplayName": "Armor",
		"Details": "Reduces Damage By an additional 1 point",
		"Level": "Level: 3",
		"Prerequisites": ["Armor2"],
		"Type": "Upgrade"
	},
	"Armor4": {
		"Icon": UPGRADES_PATH + "helmet_1.png",
		"DisplayName": "Armor",
		"Details": "Reduces Damage By an additional 1 point",
		"Level": "Level: 4",
		"Prerequisites": ["Armor3"],
		"Type": "Upgrade"
	},
	"Speed1": {
		"Icon": UPGRADES_PATH + "boots_4_green.png",
		"DisplayName": "Speed",
		"Details": "Movement Speed Increased by 50% of base speed",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Upgrade"
	},
	"Speed2": {
		"Icon": UPGRADES_PATH + "boots_4_green.png",
		"DisplayName": "Speed",
		"Details": "Movement Speed Increased by an additional 50% of base speed",
		"Level": "Level: 2",
		"Prerequisites": ["Speed1"],
		"Type": "Upgrade"
	},
	"Speed3": {
		"Icon": UPGRADES_PATH + "boots_4_green.png",
		"DisplayName": "Speed",
		"Details": "Movement Speed Increased by an additional 50% of base speed",
		"Level": "Level: 3",
		"Prerequisites": ["Speed2"],
		"Type": "Upgrade"
	},
	"Speed4": {
		"Icon": UPGRADES_PATH + "boots_4_green.png",
		"DisplayName": "Speed",
		"Details": "Movement Speed Increased an additional 50% of base speed",
		"Level": "Level: 4",
		"Prerequisites": ["Speed3"],
		"Type": "Upgrade"
	},
	"Tome1": {
		"Icon": UPGRADES_PATH + "thick_new.png",
		"DisplayName": "Tome",
		"Details": "Increases the size of spells an additional 10% of their base size",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Upgrade"
	},
	"Tome2": {
		"Icon": UPGRADES_PATH + "thick_new.png",
		"DisplayName": "Tome",
		"Details": "Increases the size of spells an additional 10% of their base size",
		"Level": "Level: 2",
		"Prerequisites": ["Tome1"],
		"Type": "Upgrade"
	},
	"Tome3": {
		"Icon": UPGRADES_PATH + "thick_new.png",
		"DisplayName": "Tome",
		"Details": "Increases the size of spells an additional 10% of their base size",
		"Level": "Level: 3",
		"Prerequisites": ["Tome2"],
		"Type": "Upgrade"
	},
	"Tome4": {
		"Icon": UPGRADES_PATH + "thick_new.png",
		"DisplayName": "Tome",
		"Details": "Increases the size of spells an additional 10% of their base size",
		"Level": "Level: 4",
		"Prerequisites": ["Tome3"],
		"Type": "Upgrade"
	},
	"Scroll1": {
		"Icon": UPGRADES_PATH + "scroll_old.png",
		"DisplayName": "Scroll",
		"Details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Upgrade"
	},
	"Scroll2": {
		"Icon": UPGRADES_PATH + "scroll_old.png",
		"DisplayName": "Scroll",
		"Details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"Level": "Level: 2",
		"Prerequisites": ["Scroll1"],
		"Type": "Upgrade"
	},
	"Scroll3": {
		"Icon": UPGRADES_PATH + "scroll_old.png",
		"DisplayName": "Scroll",
		"Details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"Level": "Level: 3",
		"Prerequisites": ["Scroll2"],
		"Type": "Upgrade"
	},
	"Scroll4": {
		"Icon": UPGRADES_PATH + "scroll_old.png",
		"DisplayName": "Scroll",
		"Details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"Level": "Level: 4",
		"Prerequisites": ["Scroll3"],
		"Type": "Upgrade"
	},
	"Ring1": {
		"Icon": UPGRADES_PATH + "urand_mage.png",
		"DisplayName": "Ring",
		"Details": "Your spells now spawn 1 more additional attack",
		"Level": "Level: 1",
		"Prerequisites": [],
		"Type": "Upgrade"
	},
	"Ring2": {
		"Icon": UPGRADES_PATH + "urand_mage.png",
		"DisplayName": "Ring",
		"Details": "Your spells now spawn an additional attack",
		"Level": "Level: 2",
		"Prerequisites": ["Ring1"],
		"Type": "Upgrade"
	},
	"Food": {
		"Icon": UPGRADES_PATH + "chunk.png",
		"DisplayName": "Food",
		"Details": "Heals you for 20 health",
		"Level": "N/A",
		"Prerequisites": [],
		"Type": "Item"
	}
}
