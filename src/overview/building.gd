extends Sprite2D
class_name Building

func _physics_process(_delta: float) -> void:
	if GameManager._tabaco_done:
		visible = false