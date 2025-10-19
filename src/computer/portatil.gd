extends Control
class_name Portatil

# Private Variables
# Should only have one child, which is the current scene shown on the computer screen.
@onready var computer_screen: Control = %ComputerScreen

var current_screen: ComputerScreen = null

# Public Functions
func get_scene_on_screen() -> ComputerScreen:
	if computer_screen.get_child_count() == 0:
		return null

	var child := computer_screen.get_child(0)
	assert(child is ComputerScreen, "Child of computer_screen must be a ComputerScreen.")
	return child as ComputerScreen

# Private Functions
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.MOUSE_CLICK)

func _ready() -> void:
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PORTATIL_MUSIC)

	assert(computer_screen != null, "ComputerScreen reference is missing.")

	current_screen = get_scene_on_screen()
	if current_screen:
		_connect_screen_signals(current_screen)
	else:
		push_warning("Portatil has no initial ComputerScreen child.")

func _connect_screen_signals(screen: ComputerScreen) -> void:
	if screen == null:
		push_warning("Tried to connect signals on a null screen.")
		return

	if not screen.has_signal("request_screen_change"):
		push_warning("Screen does not define signal 'request_screen_change'.")
		return

	screen.request_screen_change.connect(_replace_screen)

func _replace_screen(target_uid: String) -> void:
	# Free old screen safely
	if current_screen:
		current_screen.queue_free()
		current_screen = null

	# Load and instance new one
	var new_scene: PackedScene = load(target_uid)
	if new_scene == null:
		push_error("Invalid scene UID: %s" % target_uid)
		return

	var instance = new_scene.instantiate()
	if instance == null:
		push_error("Failed to instantiate scene: %s" % target_uid)
		return

	if not (instance is ComputerScreen):
		push_error("Scene '%s' is not a ComputerScreen!" % target_uid)
		instance.queue_free()
		return

	computer_screen.add_child(instance)
	current_screen = instance as ComputerScreen
	_connect_screen_signals(current_screen)
