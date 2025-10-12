extends Attack
class_name AttackKnockback

@export var knockback_force: float = 500.0

func perform_attack(target: Node2D, attacker: Node2D) -> void:
	super.perform_attack(target, attacker)

	# Apply directional knockback
	if target is CharacterBody2D:
		# Direction vector from attacker to target
		var direction = (target.global_position - attacker.global_position).normalized()
		
		# Knockback vector (direction * force)
		var kb = direction * knockback_force
		
		# Apply to target's velocity
		target.velocity += kb