## MiniGame.gd
extends ComputerScreen
class_name MiniGame

@export var time_limit: float = 60.0
@export_group("Camera Shake")
@export_range(0.0, 500.0, 1.0) var camera_shake_intensity: float = 8.0
@export_range(0.0, 5.0, 0.1) var camera_shake_duration: float = 0.5

@onready var _header: Header = $Header
@onready var _timer_ui: TextureProgressBar = $TimerUI
@onready var _camera_shake: CameraShake = %CameraShake

var timer: Timer = Timer.new()
var started: bool = false
var typed_text: String = ""
var typed_index: int = 0
var structured_text: String = ""
var placeholders: Array = []

func _ready() -> void:
	# Setup timer
	add_child(timer)
	timer.wait_time = time_limit
	timer.one_shot = true
	timer.timeout.connect(_on_time_timeout)

	_timer_ui.max_value = time_limit
	_timer_ui.value = time_limit

	# Parse the header for placeholders
	structured_text = _header.raw_text
	_parse_placeholders()

func _process(_delta: float) -> void:
	if started and timer.time_left > 0:
		_timer_ui.value = timer.time_left

func _parse_placeholders() -> void:
	placeholders.clear()
	var text = structured_text
	
	for key in _header.option_sets.keys():
		var tag = "{" + key + "}"
		var pos = 0
		
		while true:
			pos = text.find(tag, pos)
			if pos == -1:
				break
			
			var opts = _header.get_options_for_placeholder(key)
			placeholders.append({
				"start": pos,
				"end": pos + tag.length(),
				"tag": key,
				"options": opts,
				"chosen_option": - 1
			})
			pos += tag.length()

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	if not started:
		_start_game()

	var key_event = event as InputEventKey

	if key_event.unicode != 0:
		_process_typed_char(char(key_event.unicode))

func _get_placeholder_at(pos: int) -> Dictionary:
	for ph in placeholders:
		if pos >= ph["start"] and pos < ph["end"]:
			return ph
	return {}

func _process_typed_char(c: String) -> void:
	if typed_index >= structured_text.length():
		return
	
	var placeholder := _get_placeholder_at(typed_index)
	
	if placeholder:
		_handle_placeholder_typing(placeholder, c)
	else:
		_handle_normal_typing(c)
	
	_update_display()

func _handle_normal_typing(c: String) -> void:
	var expected_char = structured_text[typed_index]
	print("Expected char: '%s', typed char: '%s'" % [expected_char, c])
	if c == expected_char:
		typed_text += c
		typed_index += 1
	else:
		print("Wrong character typed: expected '%s', got '%s'" % [expected_char, c])
		_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)
		# else do nothing — player must type the correct char

func _handle_placeholder_typing(ph: Dictionary, c: String) -> void:
	var options = ph["options"]

	# If no option chosen yet, try to pick by first letter
	if ph["chosen_option"] == -1:
		var picked := -1
		for i in range(options.size()):
			if options[i].length() > 0 and options[i][0] == c:
				picked = i
				break
		if picked == -1:
			# typed char does not match any first option letter -> ignore
			return
		ph["chosen_option"] = picked
		# the first character is being typed now; check that it actually matches the first letter (it does)
		ph["progress"] = 0 # start progress at 0, we'll validate next lines

	# Ensure chosen_option is valid
	if ph["chosen_option"] < 0 or ph["chosen_option"] >= ph["options"].size():
		return

	var option = ph["options"][ph["chosen_option"]]
	var progress := int(ph["progress"]) # how many chars already typed of this option

	# The expected character to type now is option[progress]
	if progress < option.length():
		var expected_char = option[progress]
		# compare case-insensitively on input vs expected (use exact if you prefer)
		if c == expected_char:
			# accept character
			typed_text += c
			typed_index += 1
			progress += 1
			ph["progress"] = progress

			# If we've finished typing the option, move typed_index to the end of the tag
			if progress == option.length():
				# advance typed_index to after the placeholder tag in structured_text
				typed_index = ph["end"]
				# reset progress (optional)
				ph["progress"] = 0
		else:
			# wrong character for this option -> ignore (player must type correct char)
			print("Wrong character typed: expected '%s', got '%s'" % [expected_char, c])
			_camera_shake.screen_shake(camera_shake_intensity, camera_shake_duration)
			return
	else:
		# If progress is already >= option.length(), make sure we skip the tag
		typed_index = ph["end"]

func _update_display() -> void:
	var display_text := ""
	var text_pos := 0
	var typed_pos := 0

	while text_pos < structured_text.length():
		var ph := _get_placeholder_at(text_pos)
		var color: String
	
		if ph:
			var tag = "{" + ph["tag"] + "}"

			if ph["chosen_option"] == -1:
				display_text += _header.build_table_with_array_highlight(ph["options"], -1)
			else:
				var option = ph["options"][ph["chosen_option"]]
				for i in range(option.length()):
					color = "gray"
					if typed_pos < typed_text.length():
						var typed_char = typed_text[typed_pos]
						if typed_char == option[i]:
							color = "green"
							typed_pos += 1
					display_text += "[color=%s]%s[/color]" % [color, option[i]]

			text_pos += tag.length()
			continue

		# Normal character
		var expected_char := structured_text[text_pos]
		color = "gray"
		if typed_pos < typed_text.length():
			var typed_char := typed_text[typed_pos]
			if typed_char == expected_char:
				color = "green"
				typed_pos += 1
		display_text += "[color=%s]%s[/color]" % [color, expected_char]
		text_pos += 1

	_header.raw_text = display_text

func _start_game() -> void:
	started = true
	timer.start()

func _on_time_timeout() -> void:
	print("Time's up!")
	print("PLZ EXPLAIN WHAT TO DO WHEN TIME'S UP...")


func _on_publish_button_pressed() -> void:
	# Check if the player has typed all characters
	if typed_index >= structured_text.length():
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
