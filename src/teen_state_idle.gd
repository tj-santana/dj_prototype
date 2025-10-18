extends TeenState
class_name TeenStateIdle

# Public variables
@export var idle_time: float = 0.5

var _timer: Timer = null

func enter(_previous_state: State = null) -> void:
	_teen_animation_player.play("idle")
	# Stop horizontal movement
	_teen.velocity.x = 0

	# Timer setup
	_timer = Timer.new()
	_timer.wait_time = idle_time
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_timer.start()

func exit() -> void:
	# Timer cleanup
	if _timer:
		_timer.queue_free()
		_timer = null
	pass

func physics_update(delta: float) -> void:
	_teen.update_gravity(delta)
	_teen.update_velocity()

func _on_timer_timeout() -> void:
	transitioned.emit(self, "Walk")
	pass
