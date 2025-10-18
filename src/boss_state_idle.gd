extends BossState
class_name BossStateIdle

# Public variables
@export var idle_time: float = 2.0

var _timer: Timer = null

func enter(_previous_state: State = null) -> void:
	_boss_animation_tree.set_state("Idle")
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
	_boss_body.update_gravity(delta)
	_boss_body.update_velocity()

	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.COUGH)

func _on_timer_timeout() -> void:
	transitioned.emit(self, "Attack")
	pass
