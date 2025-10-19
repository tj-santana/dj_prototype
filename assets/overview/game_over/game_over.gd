extends Node2D

@onready var _earnings: RichTextLabel = %Earnings
@onready var _goodguys: RichTextLabel = %GoodGuys
@onready var _badguys: RichTextLabel = %BadGuys
@onready var _mainmenu: TextureButton = %MainMenu
var goodkills = 0
var badkills = 0

func _on_ready() -> void:
	_earnings.text= "Total Earnings ........................ "+str(GameManager.getMoney()-500)+"€"
	
	if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.GOOD:
		badkills += 1
	if GameManager.getLevelDecision(GameManager.LEVEL.TABACO) == GameManager.DECISION_TYPE.BAD:
		goodkills += 1

	_goodguys.text = "Innocent citizens killed: "+str(goodkills)
	_badguys.text = "Corrupt leaders defeated: "+str(badkills)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
			var button_rect = Rect2(_mainmenu.global_position, _mainmenu.size)
			if button_rect.has_point(event.global_position):
				await Global.game_controller.change_scene(Refs.PATHS.MAIN_MENU,"", TransitionSettings.TRANSITION_TYPE.MAIN_MENU_TO_GAME)
			
