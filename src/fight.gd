extends Node2D

func _ready() -> void:
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