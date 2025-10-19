extends Node2D
class_name Overview

@onready var mission: Button = %Mission
@onready var smog: Sprite2D = %Smog
@onready var smogBad: Sprite2D = %SmogBad


	# Button ditection is not working for som reason.
	# So intead we calculate if the click was on the area of the button.

func _input(event):
	if event is InputEventMouseButton and event.pressed and mission:
		var button_rect = Rect2(mission.global_position, mission.size)
		if button_rect.has_point(event.global_position):
			_handle_mission_click()

func _handle_mission_click():
	await Global.game_controller.change_gui_scene(Refs.PATHS.PORTATIL, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)


func _on_ready() -> void:
	var state = GameManager.getLevelDecision(GameManager.LEVEL.TABACO)
	
	match state:
		GameManager.DECISION_TYPE.GOOD:
			smog.visible = false
		GameManager.DECISION_TYPE.TODO:
			smog.visible = true
		GameManager.DECISION_TYPE.BAD:
			smog.visible = false
			smogBad.visible = true
		GameManager.DECISION_TYPE.MISS:
			smog.visible = false
			smogBad.visible = true
