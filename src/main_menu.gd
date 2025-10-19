extends Control
class_name MainMenu

@onready var play: Button = %Play
@onready var settings: Button = %Settings
@onready var quit: Button = %Quit

func _ready() -> void:
	play.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)

# Signal handlers
func _on_play_pressed() -> void:
	# Global.game_controller.change_scene("", Refs.PATHS.OVERVIEWTUTORIAL, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
	await Global.game_controller.change_scene(Refs.PATHS.FIGHT_GUI, Refs.PATHS.FIGHT, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
