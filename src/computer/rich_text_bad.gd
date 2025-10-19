@tool
extends RichTextEffect
class_name RichTextBad

# Syntax: [bad][/bad]
var bbcode = "bad"

# TODO: Add additional effects for the bad option

func _process_custom_fx(char_fx):
	# Make text bright red
	char_fx.color = Color(1.0, 0.2, 0.2) # bright red

	return true
