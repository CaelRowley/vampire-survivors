class_name HurtBox
extends Area2D

signal hurt(damage: float)

enum HurtBoxTypes {DisableHurtBox, DisableHitBox, HitOnce}

@export var hurt_box_type := HurtBoxTypes.DisableHurtBox
@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var disable_timer := $DisableTimer as Timer


func _on_area_entered(area: Area2D):
	if area.is_in_group("hit_box"):
		match hurt_box_type:
			HurtBoxTypes.DisableHurtBox:
				collision_shape.call_deferred("set", "disabled", true)
				disable_timer.start()
			HurtBoxTypes.DisableHitBox:
				area.disable_hit_box()
			HurtBoxTypes.HitOnce:
				pass
		hurt.emit(area.damage)
		area.hurt_box_hit(self)


func _on_disable_timer_timeout():
	collision_shape.call_deferred("set", "disabled", false)
