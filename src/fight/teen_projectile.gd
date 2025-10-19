extends CharacterBody2D
class_name TeenProjectile

@export var speed: float = 400.0

func _ready() -> void:
	pass

func launch(target_position: Vector2) -> void:
	# Set velocity toward the target
	velocity = (target_position - global_position).normalized() * speed
	rotation = velocity.angle()

func _physics_process(_delta: float) -> void:
	# Move the projectile
	move_and_slide()

func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	queue_free()
