extends Node2D

# Public variables
@export var sound_effect_settings: Array[SoundEffectSettings]

# Private variables
var _sound_effect_dict: Dictionary = {}
var _active_sounds: Dictionary = {}

# Private functions
func _ready():
	for sound_effect_setting: SoundEffectSettings in sound_effect_settings:
		_sound_effect_dict[sound_effect_setting.type] = sound_effect_setting

func _add_active_sound(type, player):
	if not _active_sounds.has(type):
		_active_sounds[type] = []
	_active_sounds[type].append(player)

func _remove_active_sound(type, player):
	if _active_sounds.has(type):
		_active_sounds[type].erase(player)
		if _active_sounds[type].is_empty():
			_active_sounds.erase(type)

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
			new_audio.finished.connect(func():
				_remove_active_sound(type, new_audio)
				new_audio.queue_free()
			)
			new_audio.play()
			_add_active_sound(type, new_audio)
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

func fade_out_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE, duration: float = 1.0):
	if not _active_sounds.has(type):
		return

	for player in _active_sounds[type]:
		if not is_instance_valid(player):
			continue
		var tween := create_tween()
		tween.tween_property(player, "volume_db", -80, duration)
		tween.finished.connect(func():
			if is_instance_valid(player):
				player.stop()
				_remove_active_sound(type, player)
				player.queue_free())

func stop_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if not _active_sounds.has(type):
		return

	for player in _active_sounds[type]:
		if is_instance_valid(player):
			player.stop()
			player.queue_free()
	_active_sounds.erase(type)

func get_audios(type: SoundEffectSettings.SOUND_EFFECT_TYPE) -> Array:
	if _active_sounds.has(type):
		return _active_sounds[type]
	return []

func get_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE) -> AudioStreamPlayer:
	# Returns the first active sound of this type (or null)
	if _active_sounds.has(type) and not _active_sounds[type].is_empty():
		return _active_sounds[type][0]
	return null
