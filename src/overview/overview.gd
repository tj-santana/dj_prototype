extends Node2D
class_name Overview

@onready var mission: Button = %Mission

func _ready() -> void:
	mission.pressed.connect(_on_mission_pressed)
	pass


func _on_mission_pressed() -> void:
	await Global.game_controller.change_gui_scene(Refs.PATHS.PORTATIL, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
