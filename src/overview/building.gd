extends Sprite2D
class_name Building

func _physics_process(_delta: float) -> void:
	if GameManager._tabaco_done:
		visible = false
	if GameManager.getLevelDecision(GameManager.LEVEL.PRESIDENTE) == GameManager.DECISION_TYPE.GOOD:
		visible = true
