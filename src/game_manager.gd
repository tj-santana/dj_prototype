extends Node

enum LEVEL {
	TABACO,
	VET,
	BANK,
	ELETRIC,
	PRESIDENTE
}

enum DECISION_TYPE {
	MISS,
	GOOD,
	BAD
}

@onready var _decisionLog: Dictionary
@onready var _money: int
@onready var _body_text: String = ""
@onready var _oldNews: bool

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
	
func get_body_text() -> String:
	return _body_text
	
func set_body_text(text: String) -> void:
	_body_text = text
	
func get_old_news() -> bool:
	return _oldNews
	
func set_old_news(result: bool) -> void:
	_oldNews = result
