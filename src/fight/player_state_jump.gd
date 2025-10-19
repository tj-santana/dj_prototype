extends PlayerState
class_name PlayerStateJump

# Public variables
@export var jump_force: float = 400.0
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var deceleration: float = 1500.0

func enter(_previous_state: State = null) -> void:
	_player_animation_tree.set_state("Jump")
	_player.velocity.y = - jump_force
	
func physics_update(delta: float) -> void:
	_player.update_gravity(delta)
	_player.update_input(speed, acceleration, deceleration, delta)
	_player.update_velocity()

	if _player.is_on_floor():
		transitioned.emit(self, "Idle")

	if Input.is_action_just_pressed("attack"):
		#print("Player: Attack input detected.")
		transitioned.emit(self, "Attack")