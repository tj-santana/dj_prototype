extends Control
class_name NewsPublishing

@onready var _body_label: RichTextLabel = %BodyText
@onready var _old_news_warning: RichTextLabel = %OldNewsWarning

func _ready() -> void:
	_body_label.text = GameManager.get_body_text()
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.NEWS_PUBLISHED)
	_old_news_warning.visible = GameManager.get_old_news()
	

func _on_confirm_button_pressed() -> void:
	AudioManager.fade_out_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PORTATIL_MUSIC, 0.5)
	await Global.game_controller.change_scene("", Refs.PATHS.FIGHT_TUTORIAL, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
