extends State
class_name BossState

# Private variables
var _boss: Boss = null
var _boss_body: BossBody = null
var _boss_visuals: Sprite2D = null
var _hurtbox_component: HurtboxComponent = null

func _ready() -> void:
	await owner.ready
	_boss = owner as Boss
	_boss_body = _boss._body as BossBody
	_boss_visuals = _boss_body._visuals as Sprite2D
	_hurtbox_component = _boss_body._hurtbox_component as HurtboxComponent