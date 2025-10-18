extends TeenState
class_name TeenStateAttack

const PROJECTILE = preload(Refs.PATHS.TEEN_PROJECTILE)

func enter(_previous_state: State = null) -> void:
	_teen_animation_player.play("attack")
	
	# Attack
	_shoot_projectile()

	# Transition back to Idle after attack
	transitioned.emit(self, "Idle")
	
func _shoot_projectile() -> void:
	var projectile: TeenProjectile = PROJECTILE.instantiate()
	# Add to the same parent as the teen
	_teen.add_child(projectile)

	# Spawn at teen's position
	projectile.global_position = _teen.global_position

	# Calculate direction to the player
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		projectile.launch(player.global_position)

func _on_attack_finished() -> void:
	transitioned.emit(self, "Idle")
