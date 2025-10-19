extends TeenState
class_name TeenStateDeath

func enter(_previous_state: State = null) -> void:
	print("Death State.")
	SignalBus.on_teen_died.emit()
	_teen.velocity.x = 0
	_teen_animation_player.play("death")

func physics_update(delta: float) -> void:
	_teen.update_gravity(delta)
	_teen.update_velocity()
	pass