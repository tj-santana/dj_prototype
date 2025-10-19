extends Sprite2D
class_name BuildingRuin

func _physics_process(_delta: float) -> void:
	if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.BAD:
		visible = false
	if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.MISS:
		visible = false
