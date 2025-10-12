extends CharacterBody2D
class_name Player

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
	# Connect hurtbox invincibility signals
	_hurtbox_component.invincibility_started.connect(_on_invincibility_started)
	_hurtbox_component.invincibility_ended.connect(_on_invincibility_ended)

# Visible debugging
func _draw() -> void:
	draw_line(Vector2.ZERO, debug["velocity"], Color.RED, 4.0)
	draw_circle(debug["velocity"], 6.0, Color.RED)

func _process(_delta: float) -> void:
	# Update debug info
	debug["velocity"] = velocity
	queue_redraw()

func _on_health_changed(current_health: int) -> void:
	print("Player Health Updated: %d" % current_health)

func _on_died() -> void:
	print("Player has died!")

func _on_invincibility_started() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(_visuals, "modulate:a", 0.3, 0.1)
	tween.tween_property(_visuals, "modulate:a", 1.0, 0.1)
	_visuals.set_meta("flash_tween", tween)

func _on_invincibility_ended() -> void:
	var tween = _visuals.get_meta("flash_tween")
	if tween:
		tween.kill()
	_visuals.modulate = Color(1, 1, 1, 1)

# Public Functions
func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0:
		velocity.y = 0.0 # reset on landing

func update_input(speed: float, acceleration: float, deceleration: float, delta: float) -> void:
	var input_dir: float = Input.get_axis("move_left", "move_right")

	if input_dir != 0.0:
		velocity.x = move_toward(velocity.x, input_dir * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

func update_velocity() -> void:
	move_and_slide()
