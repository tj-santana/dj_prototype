class_name CityStateManager
extends Node

var _gameState: GameManager

func update_city():
	for level in _gameState.getLevelsDone():
		if _gameState.getLevelDecision(level) == GameManager.DECISION_TYPE.BAD:
			show_bad_decision(level)
		if _gameState.getLevelDecision(level) == GameManager.DECISION_TYPE.GOOD:
			show_good_decision(level)

func show_bad_decision(level: GameManager.LEVEL):
	match level:
		GameManager.LEVEL.TABACO:
			pass #TODO: bad consequences of tabaco
		GameManager.LEVEL.VET:
			pass #TODO: bad consequences of vet
		GameManager.LEVEL.BANK:
			pass #TODO: bad consequences of bank
		GameManager.LEVEL.ELETRIC:
			pass #TODO: bad consequences of eletric
		GameManager.LEVEL.PRESIDENTE:
			pass #TODO: bad consequences of president
	
	
	
func show_good_decision(level: GameManager.LEVEL):
	match level:
		GameManager.LEVEL.TABACO:
			pass #TODO: good consequences of tabaco
		GameManager.LEVEL.VET:
			pass #TODO: good consequences of vet
		GameManager.LEVEL.BANK:
			pass #TODO: good consequences of bank
		GameManager.LEVEL.ELETRIC:
			pass #TODO: good consequences of eletric
		GameManager.LEVEL.PRESIDENTE:
			pass #TODO: good consequences of president
