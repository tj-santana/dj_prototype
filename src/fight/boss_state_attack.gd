extends BossState
class_name BossStateAttack

# Public variables
@export_group("Movement")
@export var speed_to_path: float = 200.0
@export var speed_on_path: float = 0.1
@export_group("Attack")
@export var attack_duration: float = 5.0

var _path: Path2D = null
var _path_follow: PathFollow2D = null
var _reached_path: bool = false
var _closest_point: Vector2 = Vector2.ZERO

var _timer: Timer = null

func enter(_previous_state: State = null) -> void:
	_boss_animation_tree.set_state("Attack")
	_hitbox_component.get_child(0).disabled = false
	# Make invincible
	_hurtbox_component.set_invincible(true)
	# Setup timer
	_timer = Timer.new()
	_timer.wait_time = attack_duration
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_timer.start()

	# print("Entering Attack State")
	# Choose one of the paths randomly
	_path = _boss.get_random_path()
	if _path == null:
		push_error("No path found for the boss to follow!")
		return
	if _path.get_child(0) == null:
		push_error("No PathFollow2D found as a child of the selected path!")
		return
	_path_follow = _path.get_child(0) as PathFollow2D
	_closest_point = _get_closest_point_on_path(_path)
	print("Closest point on path: ", _closest_point)

func exit() -> void:
	# Remove invincibility
	_hurtbox_component.set_invincible(false)

	# Reparent boss body back to boss
	_boss_body.reparent(_boss)
	_path = null
	_path_follow = null
	_reached_path = false
	_closest_point = Vector2.ZERO

	# Timer cleanup
	if _timer:
		_timer.queue_free()
		_timer = null
	pass

func physics_update(delta: float) -> void:
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.SMOKE)
	if not _reached_path:
		# Move boss toward the closest point
		if _boss_body.global_position.distance_to(_closest_point) > 1.0:
			_move_toward_target(_closest_point, delta, speed_to_path)
			return
		else:
			# Reached the path; only do this once
			_reached_path = true

			var local_pos = _path.to_local(_boss_body.global_position)
			var closest_offset = _path.curve.get_closest_offset(local_pos)
			var path_length = _path.curve.get_baked_length()
			_path_follow.progress_ratio = closest_offset / path_length

			_boss_body.reparent(_path_follow)
			_boss_body.position = Vector2.ZERO

	# Now follow the path
	_follow_path(delta)

func _get_closest_point_on_path(path: Path2D) -> Vector2:
	# Convert global boss position to path-local space
	var local_pos = path.to_local(_boss_body.global_position)
	
	# Find the closest offset along the curve
	var closest_offset = path.curve.get_closest_offset(local_pos)
	
	# Sample the exact point on the curve
	var closest_point = path.curve.sample_baked(closest_offset, true)
	
	# Convert back to global coordinates
	return path.to_global(closest_point)

func _move_toward_target(target: Vector2, delta: float, move_speed: float) -> void:
	# Move the boss toward the target at a given speed (pixels per second)
	var new_pos: Vector2 = _boss_body.global_position.move_toward(target, move_speed * delta)
	#print("Moving boss toward path: ", new_pos)
	_boss_body.global_position = new_pos

func _follow_path(delta: float) -> void:
	# Make boss body child of the path to follow
	_path_follow.progress_ratio += (speed_on_path * delta)

func _on_timer_timeout() -> void:
	transitioned.emit(self, "Idle")
