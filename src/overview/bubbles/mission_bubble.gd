class_name MissionBubble
extends TextBubble


func _ready() -> void:
	super._ready() # run base setup first

	# Create button
	var button := Button.new()
	button.text = "Accept"
	button.size_flags_horizontal = Control.SIZE_SHRINK_END
	button.size_flags_vertical = Control.SIZE_SHRINK_END
	button.pressed.connect(_on_accept_pressed)
	add_child(button)

	# Position it bottom-right (simple way)
	button.anchor_right = 1
	button.anchor_bottom = 1
	button.offset_right = -8
	button.offset_bottom = -8

func _on_accept_pressed() -> void:
	print("Mission accepted!")
	queue_free()
