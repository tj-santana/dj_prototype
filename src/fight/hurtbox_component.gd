extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var particle_effect: GPUParticles2D

@export_group("Invincibility")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "invincibility_enabled")
var invincibility_enabled: bool = false
@export var invincibility_time: float = 1.0

var _invincible: bool = false

signal invincibility_started
signal invincibility_ended
signal hit(attacker: Node, attack_data: Attack)

# Public Functions
func set_invincible(value: bool) -> void:
	_invincible = value

func is_invincible() -> bool:
	return _invincible

# Private Functions
func _ready() -> void:
	if not invincibility_enabled:
		area_entered.connect(_on_area_entered)

func _physics_process(_delta: float) -> void:
	if _invincible or not invincibility_enabled:
		return

	for area in get_overlapping_areas():
		if area is HitboxComponent:
			var hitbox: HitboxComponent = area
			if hitbox.attack and health_component:
				hitbox.attack.perform_attack(owner, area.owner)
				hit.emit(area.owner, hitbox.attack)
				if invincibility_enabled:
					_start_invincibility()
				return # avoid multiple hits in one frame
			else:
				push_warning("HurtboxComponent: Overlapping HitboxComponent has no attack assigned.")

func _on_area_entered(area: Area2D) -> void:
	if _invincible:
		return

	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		if hitbox.attack and health_component:
			if particle_effect:
				particle_effect.emitting = true
				var direction = (area.global_position - global_position).normalized()
				var angle = direction.angle()
				particle_effect.rotation = angle + PI / 2
			hitbox.attack.perform_attack(owner, hitbox.owner)
			hit.emit(hitbox.owner, hitbox.attack)

func _start_invincibility() -> void:
	if invincibility_enabled:
		_invincible = true
		invincibility_started.emit()
		await get_tree().create_timer(invincibility_time).timeout
		_invincible = false
		invincibility_ended.emit()