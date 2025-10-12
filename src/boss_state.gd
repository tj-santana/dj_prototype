extends State
class_name BossState

# Private variables
var _boss: Boss = null
var _boss_visuals: Sprite2D = null

func _ready() -> void:
	await owner.ready
	_boss = owner as Boss
	_boss_visuals = _boss._visuals as Sprite2D