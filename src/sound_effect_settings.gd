extends Resource
class_name SoundEffectSettings

enum SOUND_EFFECT_TYPE {
	SMOKE,
	COUGH,
	FIGHT,
	KEYBOARD_PRESS,
	TYPE_ERROR,
	CLOSE_WINDOW,
	MOUSE_CLICK,
	TIMER_ENDING,
	PORTATIL_MUSIC,
	NEWS_PUBLISHED,
	OVERVIEW_MUSIC,
}

# Public variables
@export_range(0, 10) var limit: int = 5
@export var type: SOUND_EFFECT_TYPE
@export var sound_effect: AudioStreamMP3
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0, .01) var pitch_scale = 1.0
@export_range(0.0, 1.0, .01) var pitch_randomness = 0.0

# Private variables
var _audio_count: int = 0

# Public functions
func change_audio_count(amount: int):
	_audio_count = max(0, _audio_count + amount)

func has_open_limit() -> bool:
	return _audio_count < limit

# Signal functions
func _on_audio_finished():
	change_audio_count(-1)
