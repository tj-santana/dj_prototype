extends CharacterBody2D
class_name BossBody

# Private variables
@onready var _visuals: AnimatedSprite2D = %Visuals
@onready var _health_component: HealthComponent = %HealthComponent
@onready var _hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var _hitbox_component: HitboxComponent = %HitboxComponent
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _animation_tree: AnimationTreeParameters = $AnimationTree

# Debug dictionary
var debug: Dictionary = {
	"velocity": Vector2.ZERO,
}
const GRAVITY: float = 900.0

func _ready() -> void:
	_animation_tree.active = true
	# Connect local health component signals
	_health_component.health_changed.connect(_on_health_changed)
	# Connect hurtbox signals
	_hurtbox_component.hit.connect(_on_hurtbox_hit)

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

func _on_hurtbox_hit(_attacker: Node, _attack_data: Attack) -> void:
	_animation_tree.set("parameters/conditions/hurt", true)
