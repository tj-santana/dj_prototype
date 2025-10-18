extends State
class_name TeenState

# Private variables
var _teen: Teen = null
var _teen_visuals: AnimatedSprite2D = null
var _teen_animation_player: AnimationPlayer = null

func _ready() -> void:
	await owner.ready
	_teen = owner as Teen
	_teen_visuals = _teen._visuals as AnimatedSprite2D
	_teen_animation_player = _teen._animation_player as AnimationPlayer
	_teen._health_component.died.connect(_on_died)

func _on_died() -> void:
	if self is TeenStateDeath:
		return
	transitioned.emit(self, "Death")
