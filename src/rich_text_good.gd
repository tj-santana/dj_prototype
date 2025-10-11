@tool
extends RichTextEffect
class_name RichTextGood

# Syntax: [good][/good]
var bbcode = "good"

# TODO: Add additional effects for the good option

func _process_custom_fx(char_fx):
	# Make text bright green
	char_fx.color = Color(0.2, 1.0, 0.2) # bright green

	return true
