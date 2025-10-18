extends PlayerState
class_name PlayerStateAttack

# Public variables
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var deceleration: float = 1500.0

var attack_finished: bool = false

func enter(_previous_state: State = null) -> void:
	_player_animation_tree.set_state("Attack")

func physics_update(delta: float) -> void:
	_player.update_gravity(delta)
	_player.update_input(speed, acceleration, deceleration, delta)
	_player.update_velocity()

	if attack_finished:
		attack_finished = false
		if abs(_player.velocity.x) > 0.0 and _player.is_on_floor():
			transitioned.emit(self, "Walk")
		else:
			transitioned.emit(self, "Idle")

func _on_animation_finished() -> void:
	attack_finished = true