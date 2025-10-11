## MiniGame.gd
extends ComputerScreen
class_name MiniGame

@export var time_limit: float = 60.0

@onready var _prompt: MiniGamePrompt = $MiniGamePrompt
@onready var _timer_ui: TextureProgressBar = $TimerUI

var timer: Timer = Timer.new()
var started: bool = false
var typed_text: String = ""
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

	# Parse the prompt for placeholders
	structured_text = _prompt.raw_text
	_parse_placeholders()

func _process(_delta: float) -> void:
	if started and timer.time_left > 0:
		_timer_ui.value = timer.time_left

func _parse_placeholders() -> void:
	placeholders.clear()
	var text = structured_text
	
	for key in _prompt.option_sets.keys():
		var tag = "{" + key + "}"
		var pos = 0
		
		while true:
			pos = text.find(tag, pos)
			if pos == -1:
				break
			
			var opts = _prompt.get_options_for_placeholder(key)
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
	
	var key_event = event as InputEventKey

	if not started:
		_start_game()

	if key_event.keycode == KEY_BACKSPACE:
		if typed_text.length() > 0:
			typed_text = typed_text.substr(0, typed_text.length() - 1)
			_update_prompt()
		return

	if key_event.unicode != 0:
		typed_text += char(key_event.unicode)
		_update_prompt()

func _get_placeholder_at(pos: int) -> Dictionary:
	for ph in placeholders:
		if ph["start"] == pos:
			return ph
	return {}

func _update_prompt() -> void:
	var display_text = ""
	var typed_pos = 0
	var struct_pos = 0

	while struct_pos < structured_text.length():
		var placeholder = _get_placeholder_at(struct_pos)
		
		if placeholder:
			var tag = "{" + placeholder["tag"] + "}"
			var options = placeholder["options"]
			
			# Check if we've reached this placeholder in typing
			if typed_pos < typed_text.length():
				var matched_index = -1
				
				# First character: check which option matches
				if typed_pos == 0 or not placeholder.has("_typing"):
					for i in range(options.size()):
						if options[i][0].to_lower() == typed_text[typed_pos].to_lower():
							matched_index = i
							break
				else:
					# Continue with already chosen option
					matched_index = placeholder["chosen_option"]
				
				if matched_index != -1:
					placeholder["chosen_option"] = matched_index
					var chosen_word = options[matched_index]
					var word_typed_amount = 0
					
					# Count how many characters of the chosen word have been typed
					for i in range(typed_pos, typed_text.length()):
						if word_typed_amount < chosen_word.length():
							word_typed_amount += 1
						else:
							break
					
					# Display the word with color coding
					if word_typed_amount == 0:
						display_text += _prompt.build_table_with_array_highlight(options, matched_index)
					else:
						for j in range(chosen_word.length()):
							if j < word_typed_amount:
								var typed_char_at_j = typed_text[typed_pos + j] if typed_pos + j < typed_text.length() else ""
								if typed_char_at_j == chosen_word[j]:
									display_text += "[color=green]" + chosen_word[j] + "[/color]"
								else:
									display_text += "[color=red]" + chosen_word[j] + "[/color]"
							else:
								display_text += "[color=gray]" + chosen_word[j] + "[/color]"
					
					typed_pos += word_typed_amount
				else:
					# No matching option, show table
					display_text += _prompt.build_table_with_array_highlight(options, -1)
			else:
				# Haven't reached this placeholder yet
				display_text += _prompt.build_table_with_array_highlight(options, -1)
			
			struct_pos += tag.length()
			continue

		# Normal character
		var target_char = structured_text[struct_pos]
		var typed_char = typed_text[typed_pos] if typed_pos < typed_text.length() else ""

		if typed_char == "":
			display_text += "[color=gray]" + target_char + "[/color]"
		elif typed_char == target_char:
			display_text += "[color=green]" + target_char + "[/color]"
		else:
			display_text += "[color=red]" + target_char + "[/color]"

		typed_pos += 1
		struct_pos += 1

	_prompt.raw_text = display_text

	if _is_completed_correctly():
		print("Completed successfully!")
		timer.stop()
		await Global.game_controller.change_gui_scene(Refs.PATHS.NEWS_PUBLISHING, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)

func _is_completed_correctly() -> bool:
	var final_text = structured_text

	for ph in placeholders:
		if ph["chosen_option"] == -1:
			return false # not all placeholders chosen yet
		final_text = final_text.replace("{" + ph["tag"] + "}", ph["options"][ph["chosen_option"]])

	return typed_text == final_text

func _start_game() -> void:
	started = true
	timer.start()

func _on_time_timeout() -> void:
	print("Time's up!")
	print("PLZ EXPLAIN WHAT TO DO WHEN TIME'S UP...")
