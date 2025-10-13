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

func _on_health_changed(current_health: int) -> void:
	print("Boss Health Updated: %d" % current_health)
	SignalBus.on_boss_health_changed.emit(current_health)

func _on_died() -> void:
	print("Boss has died!")
	# TODO: on_boss_died connection
	SignalBus.on_boss_died.emit()
