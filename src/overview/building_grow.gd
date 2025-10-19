extends Sprite2D
class_name BuildingGrow

func _physics_process(_delta: float) -> void:
	if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.BAD:
		scale.x = 1
		scale.y = 1
	if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.MISS:
		scale.x = 1
		scale.y = 1
