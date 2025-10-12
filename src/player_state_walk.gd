extends PlayerState
class_name PlayerStateWalk

# Public variables
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var deceleration: float = 1500.0

func physics_update(delta: float) -> void:
	_player.update_gravity(delta)
	_player.update_input(speed, acceleration, deceleration, delta)
	_player.update_velocity()

	if abs(_player.velocity.x) == 0.0 and _player.is_on_floor():
		transitioned.emit(self, "Idle")

	if Input.is_action_just_pressed("jump") and _player.is_on_floor():
		transitioned.emit(self, "Jump")
