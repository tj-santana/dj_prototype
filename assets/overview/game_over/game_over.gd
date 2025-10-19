extends Node2D

@onready var _earnings: Label = %Earnings
@onready var _goodguys: Label = %GoodGuys
@onready var _badguys: Label = %BadGuys
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
