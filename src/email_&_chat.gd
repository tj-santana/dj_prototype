extends ComputerScreen
class_name EmailAndChat

@onready var chat: PanelContainer = %Chat
@onready var email: PanelContainer = %Email

func _on_email_close_window_pressed() -> void:
	_close_panel(email)
	if not chat.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)
		
func _on_chat_close_window_pressed() -> void:
	await _close_panel(chat)
	if not email.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)

func _close_panel(panel: PanelContainer) -> void:
	# From center to scale down and fade out
	panel.pivot_offset = panel.size / 2

	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	# Animate scale down smoothly
	tween.tween_property(panel, "scale", Vector2(0.01, 0.01), 0.2)
	#tween.tween_property(panel, "modulate:a", 0.0, 0.2)

	# Wait for the tween to finish
	await tween.finished

	# After animation, hide and reset
	panel.visible = false
	panel.scale = Vector2.ONE
	panel.modulate.a = 1.0
