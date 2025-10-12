extends Resource
class_name Attack

@export var damage: int = 10

func perform_attack(target: Node2D, _attacker: Node2D) -> void:
	if target.has_node("HealthComponent"):
		var health_component = target.get_node("HealthComponent") as HealthComponent
		if health_component:
			health_component.take_damage(damage)
