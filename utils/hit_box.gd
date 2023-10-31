class_name HitBox
extends Area2D

signal hit(hit_box: HitBox, hurt_box: HurtBox)
signal died(hit_box: HitBox)

@export var damage := 1.0
@export var knockback_strength := 100.0
@export var angle := Vector2.ZERO

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var disable_timer := $DisableTimer as Timer


func disable_hit_box():
	collision_shape.call_deferred("set", "disabled", true)
	disable_timer.start()


func hurt_box_hit(hurt_box: HurtBox):
	hit.emit(self, hurt_box)


func die():
	died.emit(self)


func _on_disable_timer_timeout():
	collision_shape.call_deferred("set", "disabled", false)

