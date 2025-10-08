extends Node
class_name GameController

# Private variables
@onready var _world_2d: Node2D = $World2D
@onready var _gui: Control = $GUI
@onready var main_menu: Control = %MainMenu
@onready var _transition_controller: TransitionController = $TransitionController

var _current_2d_scene
var _current_gui_scene

# enum SceneLayer {WORLD_2D, GUI}

func _ready() -> void:
	Global.game_controller = self
	_current_gui_scene = main_menu

## Change the current 2D scene to a new 2D scene with optional transition effects.
func change_2d_scene(new_scene: String = "",
	transition_settings_type: TransitionSettings.TRANSITION_TYPE = TransitionSettings.TRANSITION_TYPE.NONE,
	delete: bool = true,
	keep_running: bool = false
) -> void:
	await _transition_controller.perform_transition_out(transition_settings_type)

	if _current_2d_scene != null:
		if delete:
			_current_2d_scene.queue_free() # Removes node entirely
		elif keep_running:
			_current_2d_scene.hide() # Keeps node in memory and running
		else:
			_world_2d.remove_child(_current_2d_scene) # Keeps node in memory but does not run
	
	if new_scene == "":
		_current_2d_scene = null
		return
	else:
		var scene = load(new_scene).instantiate()
		_world_2d.add_child(scene)
		_current_2d_scene = scene

		await _transition_controller.perform_transition_in(transition_settings_type)

## Change the current GUI scene to a new GUI scene with optional transition effects.
func change_gui_scene(new_scene: String = "",
	transition_settings_type: TransitionSettings.TRANSITION_TYPE = TransitionSettings.TRANSITION_TYPE.NONE,
	delete: bool = true,
	keep_running: bool = false
) -> void:
	await _transition_controller.perform_transition_out(transition_settings_type)

	if _current_gui_scene != null:
		if delete:
			_current_gui_scene.queue_free() # Removes node entirely
		elif keep_running:
			_current_gui_scene.hide() # Keeps node in memory and running
		else:
			_gui.remove_child(_current_gui_scene) # Keeps node in memory but does not run

	if new_scene == "":
		_current_gui_scene = null
		return
	else:
		var scene = load(new_scene).instantiate()
		_gui.add_child(scene)
		_current_gui_scene = scene

		await _transition_controller.perform_transition_in(transition_settings_type)


# ## Change from one scene to another scene, possibly changing layers and using transitions.
# func change_scene(from_layer: SceneLayer, to_layer: SceneLayer, new_scene: String,
# 	transition_settings_type: TransitionSettings.TRANSITION_TYPE = TransitionSettings.TRANSITION_TYPE.NONE,
# 	delete: bool = true,
# 	keep_running: bool = false
# ) -> void:
# 	match from_layer:
# 		SceneLayer.WORLD_2D:
# 			await change_2d_scene("", transition_settings_type, delete, keep_running)
# 		SceneLayer.GUI:
# 			await change_gui_scene("", transition_settings_type, delete, keep_running)
# 		_:
# 			push_error("Invalid from_layer: ", from_layer)

# 	match to_layer:
# 		SceneLayer.WORLD_2D:
# 			await change_2d_scene(new_scene, transition_settings_type, delete, keep_running)
# 		SceneLayer.GUI:
# 			await change_gui_scene(new_scene, transition_settings_type, delete, keep_running)
# 		_:
# 			push_error("Invalid to_layer: ", to_layer)