extends Control
class_name NewsPublishing

func _on_confirm_button_pressed() -> void:
	await Global.game_controller.change_scene("", Refs.PATHS.FIGHT, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
