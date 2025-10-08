extends Node
class_name GameController

# Private variables
@onready var _world_2d: Node2D = $World2D
@onready var _gui: Control = $GUI
@onready var main_menu: Control = %MainMenu
@onready var _transition_controller: TransitionController = $TransitionController

var _current_2d_scene
var _current_gui_scene

func _ready() -> void:
	Global.game_controller = self
	_current_gui_scene = main_menu

func change_2d_scene(new_scene: String, transition_settings_type: TransitionSettings.TRANSITION_TYPE = TransitionSettings.TRANSITION_TYPE.NONE, delete: bool = true, keep_running: bool = false) -> void:
	# Perform transition out if settings are provided
	if transition_settings_type != TransitionSettings.TRANSITION_TYPE.NONE:
		await _transition_controller.perform_transition_out(transition_settings_type)

	if _current_2d_scene != null:
		if delete:
			_current_2d_scene.queue_free() # Removes node entirely
		elif keep_running:
			_current_2d_scene.hide() # Keeps node in memory and running
		else:
			_world_2d.remove_child(_current_2d_scene) # Keeps node in memory but does not run
	var scene = load(new_scene).instantiate()
	_world_2d.add_child(scene)
	_current_2d_scene = scene

	# Perform transition in if settings are provided
	if transition_settings_type != TransitionSettings.TRANSITION_TYPE.NONE:
		await _transition_controller.perform_transition_in(transition_settings_type)

func change_gui_scene(new_scene: String, transition_settings_type: TransitionSettings.TRANSITION_TYPE = TransitionSettings.TRANSITION_TYPE.NONE, delete: bool = true, keep_running: bool = false) -> void:
	# Perform transition out if settings are provided
	if transition_settings_type != TransitionSettings.TRANSITION_TYPE.NONE:
		await _transition_controller.perform_transition_out(transition_settings_type)

	if _current_gui_scene != null:
		if delete:
			_current_gui_scene.queue_free() # Removes node entirely
		elif keep_running:
			_current_gui_scene.hide() # Keeps node in memory and running
		else:
			_gui.remove_child(_current_gui_scene) # Keeps node in memory but does not run
	var scene = load(new_scene).instantiate()
	_gui.add_child(scene)
	_current_gui_scene = scene

	# Perform transition in if settings are provided
	if transition_settings_type != TransitionSettings.TRANSITION_TYPE.NONE:
		await _transition_controller.perform_transition_in(transition_settings_type)