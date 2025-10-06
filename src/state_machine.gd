extends Node
class_name StateMachine

# Public variables
@export var initial_state: State

# Private variables
var _current_state: State
var _states: Dictionary = {}

# Private functions
func _ready() -> void:
	for child in get_children():
		if child is State:
			_states[child.name] = child
			child.transitioned.connect(Callable(self, "_on_child_transition"))
		else:
			push_warning("State Machine contains incompatible child node")
	
	# Needed or Initial state will load before player var is init 
	await owner.ready

	if initial_state:
		initial_state.enter(null)
		_current_state = initial_state

func _process(delta) -> void:
	if _current_state:
		_current_state.update(delta)
	
func _physics_process(delta) -> void:
	if _current_state:
		_current_state.physics_update(delta)

func _on_child_transition(state: State, new_state_name: String) -> void:
	if state != _current_state:
		return
		
	var new_state: State = _states.get(new_state_name)
	if !new_state:
		print("Error: New state is null for name:", new_state_name)
		return
		
	if _current_state:
		_current_state.exit()
		new_state.enter(_current_state)
	
	_current_state = new_state
