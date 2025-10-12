extends Control

# Private variables
@onready var progress_bar: ProgressBar = %BossHealthBar

func _ready() -> void:
	SignalBus.on_boss_health_changed.connect(_on_boss_health_gui_update)

func _on_boss_health_gui_update(current_health: int) -> void:
	print("Boss Health Updated: %d" % current_health)
	progress_bar.value = current_health
