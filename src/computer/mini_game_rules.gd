extends ComputerScreen
class_name MiniGameRules

func _on_confirm_button_pressed() -> void:
	change_screen(Refs.PATHS.MINI_GAME)
