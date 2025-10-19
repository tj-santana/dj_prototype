extends Node2D
class_name FightResults

@onready var win_text: RichTextLabel = %Win
@onready var loss_text: RichTextLabel = %Lose
@onready var win_results: VBoxContainer = %"Rewards Win"
@onready var loss_results: RichTextLabel = %"Rewards Loss"
@onready var win_money: RichTextLabel = %Money

func _input(event):
	# Use _input instead of _gui_input so clicks are detected even when
	# child Control nodes have mouse_filter set. Only react to left button presses.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Global.game_controller.change_scene("", Refs.PATHS.OVERVIEW, TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)


func _on_ready() -> void:
	if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.MISS:
		win_text.visible = false
		loss_text.visible = true
		win_results.visible = false
		loss_results.visible = true	
					
	else: #Win
		win_text.visible = true
		loss_text.visible = false
		win_results.visible = true
		loss_results.visible = false	
		if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.GOOD:
			win_money.text = "Money won: 500€"
			GameManager.addMoney(500)	
		else:
			win_money.text = "Money won: 1500€"
			GameManager.addMoney(1500)	
