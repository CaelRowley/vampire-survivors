class_name HurtBox
extends Area2D

signal hurt(damage: float, angle: Vector2, knockback_strength: float)

enum HurtBoxTypes {DisableHurtBox, DisableHitBox, HitOnce}

@export var hurt_box_type := HurtBoxTypes.DisableHurtBox

var hit_once_array := []

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var disable_timer := $DisableTimer as Timer


func _on_hit_box_died(hit_box: HitBox):
	if hit_once_array.has(hit_box):
		hit_once_array.erase(hit_box)


func _on_area_entered(area: Area2D):
	if area is HitBox:
		var hit_box := area as HitBox
		match hurt_box_type:
			HurtBoxTypes.DisableHurtBox:
				collision_shape.call_deferred("set", "disabled", true)
				disable_timer.start()
			HurtBoxTypes.DisableHitBox:
				hit_box.disable_hit_box()
			HurtBoxTypes.HitOnce:
				if !hit_once_array.has(hit_box):
					hit_once_array.push_back(hit_box)
					if !hit_box.is_connected("died", _on_hit_box_died):
						hit_box.connect("died", _on_hit_box_died)
				else:
					return
		hurt.emit(hit_box.damage, hit_box.angle, hit_box.knockback_strength)
		hit_box.hurt_box_hit(self)


func _on_disable_timer_timeout():
	collision_shape.call_deferred("set", "disabled", false)

