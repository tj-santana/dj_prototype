class_name TextBubble
extends Panel


@export var text: String = ""
@export var lifetime: float = 20.0 # seconds before despawning

var label: Label

func _ready() -> void:
	# Label
	label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_constant_override("margin_left", 8)
	label.add_theme_constant_override("margin_top", 4)
	add_child(label)

	mouse_filter = Control.MOUSE_FILTER_STOP
	modulate = Color(0.2, 0.2, 0.2, 0.85)

	# Timer for auto-disappear
	var timer := Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer)
	timer.start()

func _on_timeout() -> void:
	queue_free()

func spawn(position: Vector2, parent: Node) -> void:
	parent.add_child(self)
	global_position = position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		queue_free()
