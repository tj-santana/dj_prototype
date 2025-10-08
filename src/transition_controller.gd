extends Control
class_name TransitionController

# Public variables
@export var transition_settings: Array[TransitionSettings]

# Private variables
@onready var color_rect: ColorRect = $ColorRect
var _transition_settings_dict: Dictionary = {}
var _is_transitioning: bool = false

func _ready() -> void:
	for settings: TransitionSettings in transition_settings:
		_transition_settings_dict[settings.type] = settings

# Public functions
func perform_transition_out(type: TransitionSettings.TRANSITION_TYPE) -> void:
	if type == TransitionSettings.TRANSITION_TYPE.NONE:
		return # No transition to perform

	if not _transition_settings_dict.has(type):
		push_error("Transition type not found: ", type)
		return

	var settings: TransitionSettings = _transition_settings_dict[type]
	await _transition_out(settings)

func perform_transition_in(type: TransitionSettings.TRANSITION_TYPE) -> void:
	if type == TransitionSettings.TRANSITION_TYPE.NONE:
		return # No transition to perform

	if not _transition_settings_dict.has(type):
		push_error("Transition type not found: ", type)
		return

	var settings: TransitionSettings = _transition_settings_dict[type]
	await _transition_in(settings)

# Private functions
func _transition_out(settings: TransitionSettings) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	color_rect.material = settings.material_out
	await _animate_transition(0.0, 1.0, settings.duration / 2.0, settings)

func _transition_in(settings: TransitionSettings) -> void:
	color_rect.material = settings.material_in
	await _animate_transition(1.0, 0.0, settings.duration / 2.0, settings)
	_is_transitioning = false

func _animate_transition(from_val: float, to_val: float, duration: float, settings: TransitionSettings) -> void:
	var mat := color_rect.material
	# Godot doesnt have a good way to check if a shader param exists. Assure it does in the editor.
	mat.set_shader_parameter("progress", from_val)

	var tween := create_tween()
	tween.set_ease(settings.easing)
	tween.set_trans(settings.transition_type)
	tween.tween_property(mat, "shader_parameter/progress", to_val, duration)
	await tween.finished
