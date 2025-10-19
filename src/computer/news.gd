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
@onready var publish_button: TextureButton = %PublishButton

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
	if GameManager._tabaco_done:
		# HARD CODED MSM...
		header_label.text = "[b]Burla Mayor Accused of Corruption:[/b] Rumors have been spreading that some of Burla City’s taxes are being diverted into the Mayor’s personal fund. Are they true, or mere baseless accusations? The truth is that for many years, Mayor Metralha and his party have been..."
		corrupt_body.text = "defending our best interests, and any and all accusations against him are fake news! Vote Metralha, not the “canalha” 2030!"
		anticorrupt_body.text = "…taking money from the city’s accounts, disguising their withdrawals as payments for services or public renovations that never happened, for fictitious companies. The people of Burla City deserve much better than a corrupt leader, who only serves his own interests instead of the interests of the citizens! If you have any information, call or message The Daily Burla’s Tip-line: 91 234 5678."
	
	# Initialize header text
	_header_text = header_label.text
	publish_button.visible = false
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
	if GameManager._tabaco_done == false:
		GameManager.setLevelDecision(GameManager.LEVEL.TABACO, GameManager.DECISION_TYPE.GOOD)
	else:
		GameManager.setLevelDecision(GameManager.LEVEL.PRESIDENTE, GameManager.DECISION_TYPE.GOOD)
	option_chosen.emit()

func _on_corrupt_button_pressed() -> void:
	# Pitch the music down
	var music: AudioStreamPlayer = AudioManager.get_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PORTATIL_MUSIC)
	if music:
		music.pitch_scale = 0.5

	anticorrupt.visible = false
	corrupt_button.disabled = true
	corrupt_button.visible = false
	_body_text = corrupt_body.text
	_body_label = corrupt_body
	if GameManager._tabaco_done == false:
		GameManager.setLevelDecision(GameManager.LEVEL.TABACO, GameManager.DECISION_TYPE.BAD)
	else:
		GameManager.setLevelDecision(GameManager.LEVEL.PRESIDENTE, GameManager.DECISION_TYPE.BAD)
	option_chosen.emit()


func _on_mini_game_text_complete() -> void:
	publish_button.visible = true
	pass # Replace with function body.
