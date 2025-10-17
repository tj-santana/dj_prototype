extends Control
class_name NewsPublishing

func _ready() -> void:
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.NEWS_PUBLISHED)

func _on_confirm_button_pressed() -> void:
	AudioManager.fade_out_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PORTATIL_MUSIC, 0.5)
	await Global.game_controller.change_scene("", Refs.PATHS.FIGHT, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
