extends Control
class_name News

signal option_chosen

# Private Variables
@onready var header_label: RichTextLabel = %HeaderText
@onready var anticorrupt: VBoxContainer = %Anticorrupt
@onready var anti_corrupt_button: TextureButton = %AntiCorruptButton
@onready var anticorrupt_body: RichTextLabel = %AnticorruptBody
@onready var corrupt: VBoxContainer = %Corrupt
@onready var corrupt_button: TextureButton = %CorruptButton
@onready var corrupt_body: RichTextLabel = %CorruptBody

var _body_label: RichTextLabel
var _header_text: String = ""
var _body_text: String = ""

# Public Functions
func get_header_text() -> String:
	return _header_text

func get_body_text() -> String:
	return _body_text

func set_header_text(text: String) -> void:
	_header_text = text
	header_label.text = text

func set_body_text(text: String) -> void:
	_body_text = text
	_body_label.text = text

# Private Functions

func _ready() -> void:
	# Initialize header text
	_header_text = header_label.text

	# Connect button signals
	anti_corrupt_button.pressed.connect(_on_anti_corrupt_button_pressed)
	corrupt_button.pressed.connect(_on_corrupt_button_pressed)

# Signal Handlers

func _on_anti_corrupt_button_pressed() -> void:
	corrupt.visible = false
	anti_corrupt_button.disabled = true
	anti_corrupt_button.visible = false
	_body_text = anticorrupt_body.text
	_body_label = anticorrupt_body
	option_chosen.emit()

func _on_corrupt_button_pressed() -> void:
	anticorrupt.visible = false
	corrupt_button.disabled = true
	corrupt_button.visible = false
	_body_text = corrupt_body.text
	_body_label = corrupt_body
	option_chosen.emit()
