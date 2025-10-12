extends BossState
class_name BossStateIdle

# Public variables
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var deceleration: float = 1500.0

func physics_update(delta: float) -> void:
	_boss.update_gravity(delta)
	_boss.update_velocity()
