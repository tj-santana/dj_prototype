extends Camera2D
class_name CameraShake

# Private variables
var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_falloff: float = 5.0
var _shake_time: float = 0.0
var _shake_time_speed: float = 20.0
var _noise: FastNoiseLite = FastNoiseLite.new()

func _physics_process(delta: float) -> void:
	if _shake_duration > 0.0:
		_shake_time += delta * _shake_time_speed
		_shake_duration -= delta
		
		offset = Vector2(
			_noise.get_noise_2d(_shake_time, 0.0) * _shake_intensity,
			_noise.get_noise_2d(0.0, _shake_time) * _shake_intensity
		)

		_shake_intensity = max(0.0, _shake_intensity - _shake_falloff * delta)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func screen_shake(intensity: float = 0.0, duration: float = 0.0) -> void:
	randomize()
	_noise.seed = randi()
	_noise.frequency = 2.0

	_shake_intensity = intensity
	_shake_duration = duration
	_shake_time = 0.0