extends CharacterBody2D
class_name BossBody

# Private variables
@onready var _visuals: Sprite2D = %Visuals
@onready var _health_component: HealthComponent = %HealthComponent
@onready var _hurtbox_component: HurtboxComponent = %HurtboxComponent

# Debug dictionary
var debug: Dictionary = {
	"velocity": Vector2.ZERO,
}
const GRAVITY: float = 900.0

func _ready() -> void:
	# Connect local health component signals
	_health_component.health_changed.connect(_on_health_changed)
	_health_component.died.connect(_on_died)

# Visible debugging
func _draw() -> void:
	draw_line(Vector2.ZERO, debug["velocity"], Color.RED, 4.0)
	draw_circle(debug["velocity"], 6.0, Color.RED)

func _process(_delta: float) -> void:
	# Update debug info
	debug["velocity"] = velocity
	queue_redraw()

# Public Functions
func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0:
		velocity.y = 0.0 # reset on landing

func update_velocity() -> void:
	move_and_slide()

func _on_health_changed(current_health: int) -> void:
	print("Boss Health Updated: %d" % current_health)
	SignalBus.on_boss_health_changed.emit(current_health)

func _on_died() -> void:
	print("Boss has died!")
	# TODO: on_boss_died connection
	SignalBus.on_boss_died.emit()
