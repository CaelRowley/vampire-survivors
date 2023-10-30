extends Area2D

signal hurt(damage: float)

enum HurtBoxTypes {DisableHurtBox, DisableHitBox, HitOnce}

@export var hurt_box_type := HurtBoxTypes.DisableHurtBox
@onready var collision_shape = $CollisionShape2D
@onready var disable_timer = $DisableTimer


func _on_area_entered(area: Area2D):
	if area.is_in_group("hit_box") and "damage" in area:
		match hurt_box_type:
			HurtBoxTypes.DisableHurtBox:
				collision_shape.call_deferred("set", "disabled", true)
				disable_timer.start()
			HurtBoxTypes.DisableHitBox:
				if area.has_method("disable_hit_box"):
					area.disable_hit_box()
			HurtBoxTypes.HitOnce:
				pass
		hurt.emit(area.damage)


func _on_disable_timer_timeout():
	collision_shape.call_deferred("set", "disabled", false)
