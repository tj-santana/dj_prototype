extends Control
class_name NewsPublishing

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		await Global.game_controller.change_gui_scene("", TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
		await Global.game_controller.change_2d_scene(Refs.PATHS.FIGHT, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
		pass
