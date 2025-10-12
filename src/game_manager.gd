extends Node

enum LEVEL{
	TABACO,
	VET,
	BANK,
	ELETRIC,
	PRESIDENTE
}

enum DECISION_TYPE{
	MISS,
	GOOD,
	BAD
}

@onready var _decisionLog: Dictionary
@onready var _money: int

func _ready() -> void:
	for level in LEVEL:
		_decisionLog[level] = DECISION_TYPE.MISS

func getLevelDecision(level: LEVEL) -> DECISION_TYPE:
	return _decisionLog[level]

func setLevelDecision(level: LEVEL, decision: DECISION_TYPE):
	_decisionLog[level] = decision

func getMoney() -> int:
	return _money

func setMoney(money: int):
	_money = money
