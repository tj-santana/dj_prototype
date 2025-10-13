extends ComputerScreen
class_name EmailAndChat

@onready var chat: PanelContainer = %Chat
@onready var email: PanelContainer = %Email

func _on_email_close_window_pressed() -> void:
	email.visible = false
	if not chat.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)
		
func _on_chat_close_window_pressed() -> void:
	chat.visible = false
	if not email.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)
