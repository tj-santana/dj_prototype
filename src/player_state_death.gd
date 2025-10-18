extends PlayerState
class_name PlayerStateDeath

func enter(_previous_state: State = null) -> void:
	_player_animation_tree.active = false
	_player_animation_player.play("death")
	Global.game_controller.freeze_game(1.0, 0.2)
	await _player_animation_player.animation_finished
	SignalBus.on_player_died.emit()

func physics_update(delta: float) -> void:
	_player.update_gravity(delta)
	_player.update_velocity()
	pass