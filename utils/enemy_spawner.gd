extends Node2D

enum {UP, DOWN, LEFT, RIGHT}

@export var spawns: Array[SpawnInfo] = []

var time := 0

@onready var player := get_tree().get_first_node_in_group("player") as Player


func _on_timer_timeout() -> void:
	time += 1
	for spawn in spawns:
		if time >= spawn.time_start and (spawn.time_end == 0 or time <= spawn.time_end):
			if spawn.delay_counter < spawn.spawn_delay:
				spawn.delay_counter += 1
			else:
				spawn.delay_counter = 0
				var new_enemy: Resource = spawn.enemy
				var spawned_count := 0
				while spawned_count < spawn.num_to_spawn:
					var enemy_spawn: Enemy = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_postion()
					add_child(enemy_spawn)
					spawned_count += 1


func get_random_postion() -> Vector2:
	var viewport := get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left := Vector2(player.global_position.x - viewport.x/2, player.global_position.y - viewport.y/2)
	var top_right := Vector2(player.global_position.x + viewport.x/2, player.global_position.y - viewport.y/2)
	var bot_left := Vector2(player.global_position.x - viewport.x/2, player.global_position.y + viewport.y/2)
	var bot_right := Vector2(player.global_position.x + viewport.x/2, player.global_position.y + viewport.y/2)
	
	var spawn_pos1 := Vector2.ZERO
	var spawn_pos2 := Vector2.ZERO
	
	match [UP, DOWN, LEFT, RIGHT].pick_random():
		UP:
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		DOWN:
			spawn_pos1 = bot_left
			spawn_pos2 = bot_right
		LEFT:
			spawn_pos1 = top_left
			spawn_pos2 = bot_left
		RIGHT:
			spawn_pos1 = top_right
			spawn_pos2 = bot_right
	
	return Vector2(randf_range(spawn_pos1.x, spawn_pos2.x), randf_range(spawn_pos1.y, spawn_pos2.y))
