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
	TODO,
	GOOD,
	BAD
}

@onready var _decisionLog: Dictionary
@onready var _money: int = 500
@onready var _body_text: String = ""
@onready var _oldNews: bool
@onready var _tabaco_done: bool = false

func _ready() -> void:
	_decisionLog = {} # make sure it’s initialized
	for level_name in LEVEL.keys():
		var level_value = LEVEL[level_name]
		_decisionLog[level_value] = DECISION_TYPE.TODO

func getLevelDecision(level: LEVEL) -> DECISION_TYPE:
	return _decisionLog.get(level)

func setLevelDecision(level: LEVEL, decision: DECISION_TYPE):
	_decisionLog[level] = decision
	
func getLevelsDone():
	var result: Array = []
	for k in _decisionLog.keys():
		if _decisionLog[k] != DECISION_TYPE.TODO:
			result.append(k)
	return result

func getMoney() -> int:
	return _money

func setMoney(money: int):
	_money = money
	
func addMoney(money: int):
	_money += money

func get_body_text() -> String:
	return _body_text

func set_body_text(text: String) -> void:
	_body_text = text

func get_old_news() -> bool:
	return _oldNews

func set_old_news(result: bool) -> void:
	_oldNews = result
