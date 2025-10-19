extends Control
class_name OverviewTutorial

func _input(event):
	# Use _input instead of _gui_input so clicks are detected even when
	# child Control nodes have mouse_filter set. Only react to left button presses.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Global.game_controller.change_scene("", Refs.PATHS.OVERVIEW, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
