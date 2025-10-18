extends Node
class_name HealthComponent

# Public variables
@export var max_health: int = 100

# Private variable with setter
var _current_health: int = max_health: set = set_current_health, get = get_current_health

# Signals
signal health_changed(current_health: int)
signal died()

func _ready() -> void:
	# Called deferred to ensure all health_changed connections are made
	# before emitting the initial health state.
	call_deferred("set_current_health", max_health)

func get_current_health() -> int:
	return _current_health

func set_current_health(value: int) -> void:
	_current_health = clamp(value, 0, max_health)
	health_changed.emit(_current_health)
	if _current_health == 0:
		died.emit()

# Public functions
func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	#print("Taking damage: %d" % amount)
	set_current_health(_current_health - amount)

func heal(amount: int) -> void:
	if amount <= 0:
		return
	set_current_health(_current_health + amount)