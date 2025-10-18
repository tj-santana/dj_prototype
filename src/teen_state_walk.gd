extends TeenState
class_name TeenStateWalk

@export var walk_time: float = 2.0
@export var walk_speed: float = 100.0
@export var change_dir_interval: float = 0.5

var _walk_timer: Timer
var _dir_timer: Timer
var _direction: int = 1
var _was_ground_ahead: bool = true

func enter(_previous_state: State = null) -> void:
	_teen_animation_player.play("walk")
	# Setup timers
	_walk_timer = Timer.new()
	_walk_timer.wait_time = walk_time
	_walk_timer.one_shot = true
	_walk_timer.timeout.connect(_on_walk_finished)
	add_child(_walk_timer)
	_walk_timer.start()
	# Direction change timer
	_dir_timer = Timer.new()
	_dir_timer.wait_time = change_dir_interval
	_dir_timer.autostart = true
	_dir_timer.timeout.connect(_on_change_direction)
	add_child(_dir_timer)

	_on_change_direction()

func exit() -> void:
	if _walk_timer:
		_walk_timer.queue_free()
	if _dir_timer:
		_dir_timer.queue_free()

func physics_update(delta: float) -> void:
	_teen.update_gravity(delta)

	var ray = _teen._ray
	if ray and ray.is_enabled():
		var ground_ahead = ray.is_colliding()

		# Flip only on edge transition
		if _was_ground_ahead and not ground_ahead:
			_direction *= -1
			_teen.flip(_direction > 0)

		_was_ground_ahead = ground_ahead

	# Apply horizontal movement
	_teen.velocity.x = _direction * walk_speed
	_teen.update_velocity()


func _on_change_direction() -> void:
	if randf() < 0.3:
		_direction *= -1
		_teen.flip(_direction > 0)

func _on_walk_finished() -> void:
	transitioned.emit(self, "Attack")
