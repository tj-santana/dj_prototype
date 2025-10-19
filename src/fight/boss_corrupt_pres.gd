extends Node2D

var n_teens_defeated: int = 0

@onready var president: Teen = %President

func _ready() -> void:
	president._health_component.health_changed.connect(func(_current_health: int) -> void:
		SignalBus.on_boss_health_changed.emit(_current_health)
	)
	SignalBus.on_teen_died.connect(_on_teen_died)

func _on_teen_died() -> void:
	print("Teen defeated!")
	n_teens_defeated += 1
	print("Teens defeated: %d / %d" % [n_teens_defeated, get_children().size()])
	if n_teens_defeated == get_children().size():
		print("All enemies defeated!")
		SignalBus.on_boss_died.emit()