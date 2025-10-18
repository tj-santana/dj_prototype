extends State
class_name BossState

# Private variables
var _boss: Boss = null
var _boss_body: BossBody = null
var _boss_visuals: AnimatedSprite2D = null
var _boss_animation_player: AnimationPlayer = null
var _boss_animation_tree: AnimationTreeParameters = null
var _hurtbox_component: HurtboxComponent = null
var _hitbox_component: HitboxComponent = null

func _ready() -> void:
	await owner.ready
	_boss = owner as Boss
	_boss_body = _boss._body as BossBody
	_boss_visuals = _boss_body._visuals as AnimatedSprite2D
	_boss_animation_tree = _boss_body._animation_tree as AnimationTreeParameters
	_boss_animation_player = _boss_body._animation_player as AnimationPlayer
	_hurtbox_component = _boss_body._hurtbox_component as HurtboxComponent
	_hitbox_component = _boss_body._hitbox_component as HitboxComponent
	_boss_body._health_component.died.connect(_on_boss_died)

func _on_boss_died() -> void:
	if self is BossStateDeath:
		return
	transitioned.emit(self, "Death")