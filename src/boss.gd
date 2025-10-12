extends CharacterBody2D
class_name Boss

# Private variables
@onready var _visuals: Sprite2D = %Visuals
@onready var _health_component: HealthComponent = %HealthComponent

# Debug dictionary
var debug: Dictionary = {
	"velocity": Vector2.ZERO,
}
const GRAVITY: float = 900.0

func _ready() -> void:
	# Connect local health component signals
	_health_component.health_changed.connect(_on_health_changed)
	_health_component.died.connect(_on_died)

func _input(event: InputEvent) -> void:
	# TODO: remove this. Testing damage
	if event.is_action_pressed("ui_accept"):
		_health_component.take_damage(10)

# Visible debugging
func _draw() -> void:
	draw_line(Vector2.ZERO, debug["velocity"], Color.RED, 4.0)
	draw_circle(debug["velocity"], 6.0, Color.RED)

func _process(_delta: float) -> void:
	# Update debug info
	debug["velocity"] = velocity
	queue_redraw()

func _on_health_changed(current_health: int) -> void:
	SignalBus.on_boss_health_changed.emit(current_health)

func _on_died() -> void:
	print("Boss has died!")
	# TODO: on_boss_died connection
	SignalBus.on_boss_died.emit()

# Public Functions
func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0:
		velocity.y = 0.0 # reset on landing

func update_velocity() -> void:
	move_and_slide()
