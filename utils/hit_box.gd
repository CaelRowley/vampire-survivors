extends Area2D

@export var damage := 1

@onready var collision_shape = $CollisionShape2D
@onready var disable_timer = $DisableTimer


func disable_hit_box():
	collision_shape.call_deferred("set", "disabled", true)
	disable_timer.start()


func _on_disable_timer_timeout():
	collision_shape.call_deferred("set", "disabled", false)
