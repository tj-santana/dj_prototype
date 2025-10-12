extends PlayerState
class_name PlayerStateJump

# Public variables
@export var jump_force: float = 400.0
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var deceleration: float = 1500.0

func enter(_previous_state: State = null) -> void:
	_player.velocity.y = - jump_force
	
func physics_update(delta: float) -> void:
	_player.update_gravity(delta)
	_player.update_input(speed, acceleration, deceleration, delta)
	_player.update_velocity()

	if _player.is_on_floor():
		if abs(_player.velocity.x) > 0.0:
			transitioned.emit(self, "Walk")
		else:
			transitioned.emit(self, "Idle")
