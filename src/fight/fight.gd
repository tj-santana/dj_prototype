extends Node2D

const BOSS_CORRUPT = preload(Refs.PATHS.BOSS_CORRUPT)
const BOSS_ANTI_CORRUPT = preload(Refs.PATHS.BOSS_ANTI_CORRUPT)
const BOSS_CORRUPT_PRES = preload(Refs.PATHS.BOSS_CORRUPT_PRES)
const BOSS_ANTI_CORRUPT_PRES = preload(Refs.PATHS.BOSS_ANTI_CORRUPT_PRES)

func _ready() -> void:
	if !GameManager._tabaco_done:
		if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.GOOD:
			# Anti-Corrupt
			var boss_instance = BOSS_ANTI_CORRUPT.instantiate()
			add_child(boss_instance)
		else:
			# Corrupt
			var teen_instance = BOSS_CORRUPT.instantiate()
			add_child(teen_instance)
	else:
		if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.GOOD:
			# Anti-Corrupt
			var boss_instance = BOSS_ANTI_CORRUPT_PRES.instantiate()
			add_child(boss_instance)
		else:
			# Corrupt
			var teen_instance = BOSS_CORRUPT_PRES.instantiate()
			add_child(teen_instance)
	# Music
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.FIGHT)
	# Signal connections
	SignalBus.on_boss_died.connect(_on_boss_died)
	SignalBus.on_player_died.connect(_on_player_died)

func _on_boss_died() -> void:
	print("Boss defeated! Emitting last enemy died signal.")
	if !GameManager._tabaco_done:
		GameManager._tabaco_done = true
	AudioManager.fade_out_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.FIGHT, 0.5)
	await Global.game_controller.change_scene(Refs.PATHS.FIGHT_RESULTS, "", TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)

func _on_player_died() -> void:
	print("Player defeated! Emitting last enemy died signal.")
	if !GameManager._tabaco_done:
		GameManager._tabaco_done = true
	AudioManager.fade_out_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.FIGHT, 0.5)
	GameManager.setLevelDecision(GameManager.LEVEL.TABACO, GameManager.DECISION_TYPE.MISS)
	await Global.game_controller.change_scene(Refs.PATHS.FIGHT_RESULTS, "", TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
