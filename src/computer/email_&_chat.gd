extends ComputerScreen
class_name EmailAndChat

@onready var chat: PanelContainer = %Chat
@onready var email: PanelContainer = %Email

@onready var from: RichTextLabel = %From
@onready var subject: RichTextLabel = %Subject
@onready var body: RichTextLabel = %Body
@onready var dm: RichTextLabel = %DM

func _ready() -> void:
	if GameManager._tabaco_done:
		from.text = "mayor123@mayor.pt"
		subject.text = "Important im the mayor"
		body.text = "Good morning,\n\nI have seen the incredible ability you have with words. For this reason, I would personally love to have you I my PR department, as Head no less.\n\nThe offer is of around 300000$ a year. Yes those 0's are right. Just need you to write a small article defending me of the (false) accusations that have surfaced.\n\nTo our bright future,\nMayor of Burla City"
		dm.text = "[b]Grandma:[/b]Hey sweety, how are you?\n[b]Me:[/b]Doing ok grandma, how about you?\nI think I have something for you, a story maybe\nI dont know if it's of interest to you youngesters\nThe buses around the city have been coming less and less\nIts getting really hard to go to my appointments.\n[b]Me:[/b]I'll see if I can do anything\n[b]Grandma:[/b]Thank you so much sweetheart"

func _on_email_close_window_pressed() -> void:
	_close_panel(email)
	if not chat.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)
		
func _on_chat_close_window_pressed() -> void:
	await _close_panel(chat)
	if not email.visible:
		change_screen(Refs.PATHS.MINI_GAME_RULES)

func _close_panel(panel: PanelContainer) -> void:
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.CLOSE_WINDOW)

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
