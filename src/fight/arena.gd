extends Node2D
class_name Arena

@export var pres_bg: CompressedTexture2D

@onready var arena_bg: TextureRect = $Background

func _ready() -> void:
	if GameManager._tabaco_done:
		arena_bg.texture = pres_bg
		arena_bg.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
