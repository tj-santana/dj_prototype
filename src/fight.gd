extends Node2D

const BOSS_CORRUPT = preload(Refs.PATHS.BOSS_CORRUPT)
const BOSS_ANTI_CORRUPT = preload(Refs.PATHS.BOSS_ANTI_CORRUPT)

func _ready() -> void:
	if !Global.is_corrupt:
		# Anti-Corrupt
		var boss_instance = BOSS_ANTI_CORRUPT.instantiate()
		add_child(boss_instance)
	else:
		# Corrupt
		var teen_instance = BOSS_CORRUPT.instantiate()
		add_child(teen_instance)
	# Music
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.FIGHT)
	# Signal connections
	SignalBus.on_boss_died.connect(_on_boss_died)
	SignalBus.on_player_died.connect(_on_player_died)

func _on_boss_died() -> void:
	print("Boss defeated! Emitting last enemy died signal.")
	await Global.game_controller.change_scene("", Refs.PATHS.OVERVIEW, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)

func _on_player_died() -> void:
	print("Player defeated! Emitting last enemy died signal.")
	await Global.game_controller.change_scene("", Refs.PATHS.OVERVIEW, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)