extends BossState
class_name BossStateDeath

func enter(_previous_state: State = null) -> void:
	_boss_animation_tree.active = false
	_boss_animation_player.play("death")
	Global.game_controller.freeze_game(1.0, 0.2)
	await _boss_animation_player.animation_finished
	SignalBus.on_boss_died.emit()

func physics_update(delta: float) -> void:
	_boss_body.update_gravity(delta)
	_boss_body.update_velocity()
	pass