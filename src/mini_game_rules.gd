extends ComputerScreen
class_name MiniGameRules

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		change_screen(Refs.PATHS.MINI_GAME)
