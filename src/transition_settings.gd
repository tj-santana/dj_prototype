extends Resource
class_name TransitionSettings

enum TRANSITION_TYPE {
	NONE,
	MAIN_MENU_TO_GAME
}

@export var type: TRANSITION_TYPE = TRANSITION_TYPE.NONE
@export var material_out: ShaderMaterial
@export var material_in: ShaderMaterial
@export var duration: float = 1.0
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
