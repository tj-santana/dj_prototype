## MiniGame.gd
extends ComputerScreen
class_name MiniGame

signal text_complete

# Public Variables
@export var time_limit: float = 300.0
@export_group("Camera Shake")
@export_range(0.0, 500.0, 1.0) var camera_shake_intensity: float = 8.0
@export_range(0.0, 5.0, 0.1) var camera_shake_duration: float = 0.5

# Private Variables
@onready var _timer_ui: TextureProgressBar = %Timer
@onready var _news: News = %News
@onready var _camera_shake: CameraShake = %CameraShake

var timer: Timer = Timer.new()
var started: bool = false
var typed_text: String = ""
var typed_index: int = 0
var header_text: String = ""
var body_text: String = ""
var typing_header: bool = true
var original_header_text: String = ""
var original_body_text: String = ""

func _ready() -> void:
	# Setup timer
	add_child(timer)
	timer.wait_time = time_limit
	timer.one_shot = true
	timer.timeout.connect(_on_time_timeout)

	_timer_ui.max_value = time_limit
	_timer_ui.value = time_limit

	# Connect signals
	_news.option_chosen.connect(_on_option_chosen)

func _process(_delta: float) -> void:
	if started and timer.time_left > 0:
		_timer_ui.value = timer.time_left

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.unicode == 0:
		return

	if started:
		_process_typed_char(char(event.unicode))
	else:
		_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)

func _process_typed_char(c: String) -> void:
	if typing_header:
		_process_header_typing(c)
	else:
		_process_body_typing(c)
	
	# DEBUG
	#var expected_text := header_text if typing_header else body_text
	#print("Expected:", expected_text) # shows continuous text
	#print("Typed index:", typed_index)
	#print("Next char to type:", expected_text[typed_index] if typed_index < expected_text.length() else "END")

func _process_header_typing(c: String) -> void:
	if typed_index >= header_text.length():
		# Header is done — move on to body
		typing_header = false
		typed_index = 0
		typed_text = ""
		_update_body_display()
		return

	var expected_char = header_text[typed_index]

	if c == expected_char:
		typed_text += c
		typed_index += 1
	else:
		_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)

	_update_header_display()

	# If header is fully typed, switch automatically
	if typed_index >= header_text.length():
		typing_header = false
		typed_index = 0
		typed_text = ""
		_update_body_display()


func _process_body_typing(c: String) -> void:
	if typed_index >= body_text.length():
		return
	
	var expected_char = body_text[typed_index]
	if c == expected_char:
		typed_text += c
		typed_index += 1
		if typed_index==body_text.length():
			text_complete.emit()
	else:
		_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)

	_update_body_display()

func _update_header_display() -> void:
	var colored := _colorize_bbcode_text(original_header_text, header_text, typed_text)
	_news.set_header_text(colored)

func _update_body_display() -> void:
	var colored := _colorize_bbcode_text(original_body_text, body_text, typed_text)
	_news.set_body_text(colored)

# This preserves all original BBCode (like [b], [i], etc.)
func _colorize_bbcode_text(original_bbcode: String, clean_text: String, typed: String) -> String:
	var result := ""
	var visible_index := 0
	var inside_tag := false

	for i in range(original_bbcode.length()):
		var c := original_bbcode[i]

		if c == "\n":
			result += "\n" # just copy it as is
			# do not increment visible_index, because player doesn't type newline
			continue

		# Detect BBCode tags and copy them verbatim
		if c == "[":
			inside_tag = true
			result += c
			continue
		elif c == "]" and inside_tag:
			inside_tag = false
			result += c
			continue

		if inside_tag:
			result += c
			continue

		# c is a visible character (not part of BBCode)
		var color := "gray"
		if visible_index < typed.length() and typed[visible_index] == clean_text[visible_index]:
			color = "green"

		result += "[color=%s]%s[/color]" % [color, c]
		visible_index += 1

	return result

# This removes all BBCode tags, leaving only visible text
func _strip_bbcode(text: String) -> String:
	var result := ""
	var inside_tag := false
	for c in text:
		if c == "[":
			inside_tag = true
			continue
		elif c == "]":
			inside_tag = false
			continue
		if not inside_tag:
			if c != "\n": # ignore newlines completely
				result += c
	return result

# Signal Handlers
# Start Game
func _on_option_chosen() -> void:
	started = true
	timer.start()
	# Get original BBCode text
	original_header_text = _news.get_header_text()
	original_body_text = _news.get_body_text()
	# Strip BBCode for typing comparison
	header_text = _strip_bbcode(original_header_text)
	body_text = _strip_bbcode(original_body_text)
	typing_header = true
	typed_index = 0
	typed_text = ""
	_update_header_display()
	_update_body_display()

# Time's up
func _on_time_timeout() -> void:
	print("Time's up!")
	print("Become old news!")

# Publish button pressed
func _on_publish_button_pressed() -> void:
	# Check if the player has typed all characters
	if not typing_header and typed_text.length() == body_text.length():
		print("All text typed correctly! Publishing...")
		# Do whatever happens after completion
		timer.stop()
		await Global.game_controller.change_gui_scene(
			Refs.PATHS.NEWS_PUBLISHING,
			TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME
		)
	else:
		print("Text not fully typed yet!")
		# Optionally give feedback, e.g. shake camera
		_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)
