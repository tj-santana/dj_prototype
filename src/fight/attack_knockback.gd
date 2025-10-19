extends Attack
class_name AttackKnockback

@export var knockback_force: Vector2 = Vector2(500, -200)

func perform_attack(target: Node2D, attacker: Node2D) -> void:
	super.perform_attack(target, attacker)

	# Apply directional knockback
	if target is CharacterBody2D:
		var horizontal_dir = sign(target.global_position.x - attacker.global_position.x) # +1 or -1
		# Apply knockback
		target.velocity.x += horizontal_dir * knockback_force.x
		target.velocity.y = knockback_force.y # fixed upward force