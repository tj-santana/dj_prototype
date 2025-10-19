extends PlayerState
class_name PlayerStateDeath

@export var deceleration: float = 500.0

func enter(_previous_state: State = null) -> void:
	_player_animation_tree.active = false
	_player_animation_player.play("death")
	Global.game_controller.freeze_game(1.0, 0.2)
	await _player_animation_player.animation_finished
	SignalBus.on_player_died.emit()

func physics_update(delta: float) -> void:
	_player.velocity = Vector2(move_toward(_player.velocity.x, 0.0, deceleration * delta), _player.velocity.y)
	_player.update_gravity(delta)
	_player.update_velocity()
	pass