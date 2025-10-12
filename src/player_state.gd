extends State
class_name PlayerState

# Private variables
var _player: Player = null
var _player_visuals: Sprite2D = null

func _ready() -> void:
	await owner.ready
	_player = owner as Player
	_player_visuals = _player._visuals as Sprite2D
