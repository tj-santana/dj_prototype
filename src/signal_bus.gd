extends Node

# Signal bus for global events

@warning_ignore("unused_signal")
signal on_boss_health_changed(current_health: int)
@warning_ignore("unused_signal")
signal on_boss_died()