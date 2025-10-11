@tool
extends RichTextLabel
class_name MiniGamePrompt

@export_multiline var raw_text: String:
	set(value):
		raw_text = value
		_update_display_text()
	get:
		return raw_text

@export var option_sets: Dictionary = {
	"options_0": ["Good", "Bad"],
	"options_1": ["Yes", "No"]
}

func get_options_for_placeholder(tag: String) -> Array:
	return option_sets.get(tag, [])

func _ready() -> void:
	bbcode_enabled = true
	_update_display_text()

func _update_display_text() -> void:
	if not raw_text.is_empty():
		text = _replace_placeholders(raw_text)
	else:
		text = ""

func _replace_placeholders(original_text: String) -> String:
	var new_text = original_text
	for key in option_sets.keys():
		var tag = "{" + key + "}"
		while new_text.find(tag) != -1:
			var options_array: Array = option_sets[key]
			var pos = new_text.find(tag)
			var before = new_text.substr(0, pos)
			var after = new_text.substr(pos + tag.length())
			new_text = before + build_table_with_array_highlight(options_array, -1) + after
	return new_text

func build_table_with_array_highlight(options: Array, highlight_index: int = -1) -> String:
	var bbcode = "[table=1,center]"
	for i in range(options.size()):
		var option = options[i]
		var color_tag = "good" if i == 0 else "bad"
		var cell_text = option
		if i == highlight_index:
			cell_text = "[u][b]" + option + "[/b][/u]"
		bbcode += "[cell][center][" + color_tag + "]" + cell_text + "[/" + color_tag + "][/center][/cell]"
	bbcode += "[/table]"
	return bbcode