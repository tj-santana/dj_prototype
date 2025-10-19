extends Node
class_name State

@warning_ignore("unused_signal")
signal transitioned

# Virtual functions to override
func enter(_previous_state: State = null) -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
