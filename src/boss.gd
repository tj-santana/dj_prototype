extends Node2D
class_name Boss

# Private variables
@onready var _body: BossBody = %BossBody
@onready var _paths: Node2D = %Paths

func get_random_path() -> Path2D:
	for child in _paths.get_children():
		if not (child is Path2D):
			push_error("Non-Path2D child found in Paths node: %s" % child.name)
			return null
	return _paths.get_children().pick_random() as Path2D