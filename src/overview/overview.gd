extends Node2D
class_name Overview

@onready var tabacomission: Button = %TabacoMission
@onready var presmission: Button = %PresMission
@onready var smog: Sprite2D = %Smog
@onready var smogBad: Sprite2D = %SmogBad
@onready var factoryWarning: Sprite2D = %FactoryWarning
@onready var endWeek: TextureButton = %EndWeek


	# Button ditection is not working for som reason.
	# So intead we calculate if the click was on the area of the button.

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if tabacomission.disabled == false:
			var button_rect = Rect2(tabacomission.global_position, tabacomission.size)
			if button_rect.has_point(event.global_position):
				_handle_mission_click()
#		if presmission.disabled == false:
#			var button_rect = Rect2(presmission.global_position, presmission.size)
#			if button_rect.has_point(event.global_position):
#				_handle_mission_click()
		if endWeek.disabled == false:
			var button_rect = Rect2(endWeek.global_position, endWeek.size)
			if button_rect.has_point(event.global_position):
				AudioManager.stop_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.OVERVIEW_MUSIC)
				await Global.game_controller.change_scene("", Refs.PATHS.GAME_OVER, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
				

func _handle_mission_click():
	AudioManager.stop_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.OVERVIEW_MUSIC)
	await Global.game_controller.change_gui_scene(Refs.PATHS.PORTATIL, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)


func _ready() -> void:
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.OVERVIEW_MUSIC)
	var tabacostate = GameManager.getLevelDecision(GameManager.LEVEL.TABACO)
	
	#TEMPORARY:
	if tabacostate != GameManager.DECISION_TYPE.TODO:
		endWeek.visible = true
	
	
	tabacomission.visible = false
	#presmission.visible = true
	match tabacostate:
		GameManager.DECISION_TYPE.GOOD:
			smog.visible = false
			factoryWarning.visible=false
			tabacomission.disabled = true
		GameManager.DECISION_TYPE.TODO:
			smog.visible = true
			tabacomission.visible = true
#			presmission.visible = false
			return
		GameManager.DECISION_TYPE.BAD:
			smog.visible = false
			smogBad.visible = true
			factoryWarning.visible=false
			tabacomission.disabled = true
		GameManager.DECISION_TYPE.MISS:
			smog.visible = false
			smogBad.visible = true
			factoryWarning.visible = false
			tabacomission.disabled = true
