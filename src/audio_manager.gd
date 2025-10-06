extends Node2D

# Public variables
@export var sound_effect_settings: Array[SoundEffectSettings]

# Private variables
var _sound_effect_dict: Dictionary = {}

# Private functions
func _ready():
	var i: int = 0
	for sound_effect_setting: SoundEffectSettings in sound_effect_settings:
		_sound_effect_dict[i] = sound_effect_setting
		i += 1

# Public functions
func create_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if _sound_effect_dict.has(type):
		var sound_effect_setting: SoundEffectSettings = _sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect_setting.sound_effect
			new_audio.volume_db = sound_effect_setting.volume
			new_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_audio.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_audio.finished.connect(sound_effect_setting._on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)

func create_2d_audio_at_location(location: Vector2, type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if _sound_effect_dict.has(type):
		var sound_effect_setting: SoundEffectSettings = _sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_audio)
			new_audio.stream = sound_effect_setting.sound_effect
			new_audio.volume_db = sound_effect_setting.volume
			new_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_audio.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_audio.position = location
			new_audio.finished.connect(sound_effect_setting._on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)