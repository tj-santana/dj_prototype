extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

@export_group("Invincibility")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "invincibility_enabled")
var invincibility_enabled: bool = false
@export var invincibility_time: float = 1.0

var _invincible: bool = false

signal invincibility_started
signal invincibility_ended

func _physics_process(_delta: float) -> void:
	if _invincible:
		return

	for area in get_overlapping_areas():
		if area is HitboxComponent:
			var hitbox: HitboxComponent = area
			if hitbox.attack and health_component:
				hitbox.attack.perform_attack(owner, area.owner)

				if invincibility_enabled:
					_start_invincibility()
				return # avoid multiple hits in one frame

func _start_invincibility() -> void:
	if invincibility_enabled:
		_invincible = true
		invincibility_started.emit()
		await get_tree().create_timer(invincibility_time).timeout
		_invincible = false
		invincibility_ended.emit()