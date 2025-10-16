extends Control

# Public variables
@export var heart_full: Texture2D
@export var heart_half: Texture2D
@export var heart_size: float = 50.0 # Size of each heart icon in pixels

# Private variables
@onready var boss_health_bar: TextureProgressBar = %BossHealthBar
@onready var player_health_bar: HBoxContainer = %PlayerHealthBar

func _ready() -> void:
	SignalBus.on_boss_health_changed.connect(_on_boss_health_gui_update)
	SignalBus.on_player_health_changed.connect(_on_player_health_gui_update)

func _on_boss_health_gui_update(current_health: int) -> void:
	print("Boss Health Updated: %d" % current_health)
	boss_health_bar.value = current_health

func _on_player_health_gui_update(current_health: int) -> void:
	print("Player Health Updated: %d" % current_health)

	for child in player_health_bar.get_children():
		child.queue_free()

	var full_hearts := int(floor(current_health / 2.0))
	var has_half := current_health % 2 == 1

	# Add half heart if needed
	if has_half:
		var heart = TextureRect.new()
		heart.texture = heart_half
		heart.flip_h = true
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
		heart.custom_minimum_size = Vector2(heart_size, heart_size)
		player_health_bar.add_child(heart)

	# Add full hearts
	for i in range(full_hearts):
		var heart = TextureRect.new()
		heart.texture = heart_full
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
		heart.custom_minimum_size = Vector2(heart_size, heart_size)
		player_health_bar.add_child(heart)
