extends CharacterBody2D
class_name Teen

@onready var _visuals: AnimatedSprite2D = %Visuals
@onready var _health_component: HealthComponent = %HealthComponent
@onready var _hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _ray_anchor: Node2D = %RayAnchor
@onready var _ray: RayCast2D = %RayCast2D

var is_dead: bool = false
# Debug dictionary
var debug: Dictionary = {
	"velocity": Vector2.ZERO,
}
const GRAVITY: float = 900.0

# Private functions
func _ready() -> void:
	# Connect local health component signals
	_hurtbox_component.hit.connect(_on_hit)

# Visible debugging
func _draw() -> void:
	#draw_line(Vector2.ZERO, debug["velocity"], Color.RED, 4.0)
	#draw_circle(debug["velocity"], 6.0, Color.RED)
	pass

func _process(_delta: float) -> void:
	# Update debug info
	debug["velocity"] = velocity
	queue_redraw()

func _on_hit(_attacker: Node, _attack_data: Attack) -> void:
	var mat := _visuals.material
	if not mat:
		return
	# Create a tween
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/make_white", true, 0.075)
	tween.tween_property(mat, "shader_parameter/make_white", false, 0.075)
	tween.tween_property(mat, "shader_parameter/make_white", true, 0.075)
	tween.tween_property(mat, "shader_parameter/make_white", false, 0.075)

# Public Functions
func flip(facing_right: bool) -> void:
	_ray_anchor.scale.x = 1 if facing_right else -1
	_visuals.flip_h = not facing_right

func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif velocity.y > 0:
		velocity.y = 0.0 # reset on landing

func update_velocity() -> void:
	move_and_slide()
