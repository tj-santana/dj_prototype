extends Node2D
class_name BossCorrupt

var n_teens_defeated: int = 0

func _ready() -> void:
	SignalBus.on_teen_died.connect(_on_teen_died)

func _on_teen_died() -> void:
	print("Teen defeated!")
	n_teens_defeated += 1
	print("Teens defeated: %d / %d" % [n_teens_defeated, get_children().size()])
	if n_teens_defeated == get_children().size():
		print("All enemies defeated!")
		SignalBus.on_boss_died.emit()