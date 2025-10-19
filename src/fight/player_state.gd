extends State
class_name PlayerState

# Private variables
var _player: Player = null
var _player_visuals: AnimatedSprite2D = null
var _player_animation_tree: AnimationTreeParameters = null
var _player_animation_player: AnimationPlayer = null

func _ready() -> void:
	await owner.ready
	_player = owner as Player
	_player_visuals = _player._visuals as AnimatedSprite2D
	_player_animation_tree = _player._animation_tree as AnimationTreeParameters
	_player_animation_player = _player._animation_player as AnimationPlayer
	_player._health_component.died.connect(_on_died)

func _on_died() -> void:
	if self is PlayerStateDeath:
		return
	transitioned.emit(self, "Death")
