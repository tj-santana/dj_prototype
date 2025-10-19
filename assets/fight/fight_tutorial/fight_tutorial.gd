extends Node2D
class_name FightTutorial

@onready var boss_preview: Sprite2D = %Bosspreview
@onready var boss_text: RichTextLabel = %BossText
@onready var teens_preview: Sprite2D = %Teenspreview
@onready var teens_text: RichTextLabel = %TeensText
@onready var mayor_preview: Sprite2D = %MayorPreview
@onready var mayor_text: RichTextLabel = %MayorText
@onready var homeless_preview: Sprite2D = %Homelesspreview
@onready var homeless_text: RichTextLabel = %HomelessText

func _input(event):
	# Use _input instead of _gui_input so clicks are detected even when
	# child Control nodes have mouse_filter set. Only react to left button presses.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Global.game_controller.change_scene(Refs.PATHS.FIGHT_GUI, Refs.PATHS.FIGHT, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)


func _on_ready() -> void:
	if GameManager._tabaco_done == false:
		if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.GOOD:
			boss_preview.visible = true
			boss_text.visible = true
			teens_preview.visible = false
			teens_text.visible = false
		else:
			boss_preview.visible = false
			boss_text.visible = false
			teens_preview.visible = true
			teens_text.visible = true
	else:
		if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.GOOD:
			boss_preview.visible = false
			boss_text.visible = false
			teens_preview.visible = false
			teens_text.visible = false
			mayor_preview.visible = true
			mayor_text.visible = true
		else:
			boss_preview.visible = false
			boss_text.visible = false
			teens_preview.visible = false
			teens_text.visible = false
			homeless_preview.visible = true
			homeless_text.visible = true
