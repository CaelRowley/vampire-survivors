class_name Player
extends CharacterBody2D

const ItemContainer := preload("res://player/gui/item_container.tscn")

@export var speed := 100.0
@export var health := 100.0
@export var max_health := 100.0

@export var armor := 0
@export var bonus_speed := 0.0
@export var spell_size := 1.0
@export var spell_cooldown := 0.0
@export var additional_attacks := 0


var last_movement_dir := Vector2.UP

var experience := 0
var experience_level := 1
var experience_required := 5

var ice_spear := preload("res://player/attacks/ice_spear.tscn")
var ice_spear_ammo := 0
var ice_spear_base_ammo := 0
var ice_spear_attack_speed := 1.5
var ice_spear_level := 0

var tornado := preload("res://player/attacks/tornado.tscn")
var tornado_ammo := 0
var tornado_base_ammo := 0
var tornado_attack_speed := 3.0
var tornado_level := 0

var javelin := preload("res://player/attacks/javelin.tscn")
var javelin_ammo := 0
var javelin_level := 0

var enemies_in_range: Array[Enemy] = []
var collected_upgrades := []
var upgrade_options := []
var time := 0

@onready var ice_spear_timer: Timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer: Timer = ice_spear_timer.get_node("AttackTimer")
@onready var tornado_timer: Timer = $Attack/TornadoTimer
@onready var tornado_attack_timer: Timer = tornado_timer.get_node("AttackTimer")
@onready var javelins = $Attack/Javelins

@onready var character_sprite: AnimatedSprite2D = %CharacterSprite

@onready var exp_bar := %ExpBar as TextureProgressBar
@onready var label_level := %LabelLevel as Label
@onready var panel_level_up := %PanelLevelUp as Panel
@onready var audio_level_up := %AudioLevelUp as AudioStreamPlayer
@onready var vbox_upgrade_options := %UpgradeOptions as VBoxContainer
@onready var item_option := preload("res://utils/item_option.tscn")
@onready var health_bar = %HealthBar
@onready var label_timer = %LabelTimer
@onready var collected_weapons_grid = %CollectedWeapons
@onready var collected_upgrades_grid = %CollectedUpgrades


func _ready() -> void:
	upgrade_character("Javelin1")
	set_weapons()
	set_exp_bar(experience, experience_required)
	health_bar.max_value = max_health
	health_bar.value = health
	


func _physics_process(_delta: float) -> void:
	var x_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input := Input.get_action_strength("down") - Input.get_action_strength("up")
	var movement_dir := Vector2(x_input, y_input)
	
	if movement_dir != Vector2.ZERO:
		last_movement_dir = movement_dir
		if !character_sprite.is_playing():
			character_sprite.set_frame(1)
			character_sprite.play()
	else:
		if character_sprite.is_playing():
			character_sprite.stop()
	
	if character_sprite.is_playing():
		character_sprite.flip_h = movement_dir.x > 0
		
	velocity = movement_dir.normalized() * (speed + bonus_speed)
	move_and_slide()


func set_weapons() -> void:
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed * (1.0 - spell_cooldown)
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attack_speed * (1.0 - spell_cooldown)
		if tornado_timer.is_stopped():
			tornado_timer.start()
	if javelin_level > 0:
		var javelin_count := javelins.get_child_count()
		var spawn_count := (javelin_ammo + additional_attacks) - javelin_count
		while  spawn_count > 0:
			var new_javelin := javelin.instantiate() as Node2D
			javelins.add_child(new_javelin)
			new_javelin.global_position = global_position
			spawn_count -= 1
		for child in javelins.get_children():
			if child.has_method("update_javelin"):
				child.update_javelin()


func get_random_target() -> Vector2:
	if enemies_in_range.is_empty():
		return Vector2.ZERO
	return enemies_in_range.pick_random().global_position


func calculate_exp(new_experience: int) -> void:
	experience += new_experience
	if experience >= experience_required:
		level_up()
	set_exp_bar(experience, experience_required)


func set_exp_bar(new_value: int, new_max_value: int) -> void:
	exp_bar.value = new_value
	exp_bar.max_value = new_max_value


func level_up() -> void:
	audio_level_up.play()
	experience = experience - experience_required
	experience_level += 1
	experience_required *= 2
	label_level.text = str("Level: ", experience_level)
	
	var tween := panel_level_up.create_tween()
	tween.tween_property(panel_level_up, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	panel_level_up.visible = true
	
	var options := 0
	var options_max := 3
	while options < options_max:
		var option_choice := item_option.instantiate()
		option_choice.item = get_rand_item()
		vbox_upgrade_options.add_child(option_choice)
		options += 1
	
	get_tree().paused = true
	

func upgrade_character(upgrade: String) -> void:
	match upgrade:
		"IceSpear1":
			ice_spear_level = 1
			ice_spear_base_ammo += 1
		"IceSpear2":
			ice_spear_level = 2
			ice_spear_base_ammo += 1
		"IceSpear3":
			ice_spear_level = 3
		"IceSpear4":
			ice_spear_level = 4
			ice_spear_base_ammo += 2
		"Tornado1":
			tornado_level = 1
			tornado_base_ammo += 1
		"Tornado2":
			tornado_level = 2
			tornado_base_ammo += 1
		"Tornado3":
			tornado_level = 3
			tornado_attack_speed -= 0.5
		"Tornado4":
			tornado_level = 4
			tornado_base_ammo += 1
		"Javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"Javelin2":
			javelin_level = 2
		"Javelin3":
			javelin_level = 3
		"Javelin4":
			javelin_level = 4
		"Armor1","Armor2","Armor3","Armor4":
			armor += 1
		"Speed1","Speed2","Speed3","Speed4":
			bonus_speed += 20.0
		"Tome1","Tome2","Tome3","Tome4":
			spell_size += 1.10
		"Scroll1","Scroll2","Scroll3","Scroll4":
			spell_cooldown += 0.05
		"Ring1","Ring2":
			additional_attacks += 1
		"Food":
			health += 20
			health = clamp(health,0,max_health)
	update_upgrade_grid(upgrade)
			
	for child in vbox_upgrade_options.get_children():
		child.queue_free()
	upgrade_options.clear()
	collected_upgrades.push_back(upgrade)
	get_tree().paused = false
	panel_level_up.position = Vector2(220, 360)
	calculate_exp(0)
	set_weapons()


func get_rand_item() -> String:
	var db_list := []
	for upgrade in UpgradeDb.UPGRADES:
		if upgrade in collected_upgrades:
			pass
		elif upgrade in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[upgrade]["Type"] == "Item":
			pass
		elif UpgradeDb.UPGRADES[upgrade]["Prerequisites"].size() > 0:
			var prerequisites_met := true
			for prerequisite in UpgradeDb.UPGRADES[upgrade]["Prerequisites"]:
				if not prerequisite in collected_upgrades:
					prerequisites_met = false
			if prerequisites_met:
				db_list.push_back(upgrade)
		else:
			db_list.push_back(upgrade)

	if !db_list.is_empty():
		var rand_item = db_list.pick_random()
		upgrade_options.push_back(rand_item)
		return rand_item
	else:
		return "Food"


func update_upgrade_grid(upgrade_name: String) -> void:
	var upgrade = UpgradeDb.UPGRADES[upgrade_name]
#	var name = upgrade.DisplayName
	if upgrade.Type != "Item":
		var upgrade_display_names = []
		for collected_upgrade in collected_upgrades:
			upgrade_display_names.push_back(UpgradeDb.UPGRADES[collected_upgrade].DisplayName)
		if not upgrade.DisplayName in upgrade_display_names:
			var new_item := ItemContainer.instantiate()
			new_item.upgrade = upgrade_name
			match upgrade.Type:
				"Weapon":
					collected_weapons_grid.add_child(new_item)
				"Upgrade":
					collected_upgrades_grid.add_child(new_item)


func _on_hurt_box_hurt(damage: float, _angle: Vector2, _knockback_strength: float) -> void:
	health -= maxf(damage-armor, 1.0)
	health_bar.value = health
	if health <= 0:
		print("dead")


func _on_enemy_detection_body_entered(body: Enemy) -> void:
	if !enemies_in_range.has(body):
		enemies_in_range.push_back(body)


func _on_enemy_detection_body_exited(body: Enemy) -> void:
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)


func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo + additional_attacks
	ice_spear_attack_timer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var new_ice_spear := ice_spear.instantiate() as Node2D
		new_ice_spear.position = position
		new_ice_spear.target_pos = get_random_target()
		new_ice_spear.level = ice_spear_level
		add_child(new_ice_spear)
		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()


func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_base_ammo + additional_attacks
	tornado_attack_timer.start()


func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var new_tornado := tornado.instantiate() as Node2D
		new_tornado.position = position
		new_tornado.target_pos = get_random_target()
		new_tornado.last_movement_dir = last_movement_dir
		new_tornado.level = tornado_level
		add_child(new_tornado)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
		else:
			tornado_attack_timer.stop()


func _on_grab_area_area_entered(area: ExpGem) -> void:
	area.target = self


func _on_collect_area_area_entered(area: ExpGem) -> void:
	calculate_exp(area.collect())
	

func _on_second_timer_timeout():
	time += 1
	var minutes := int(time/60)
	var seconds := time % 60
	label_timer.text = str("%02d" % minutes, ":", "%02d" % seconds)
