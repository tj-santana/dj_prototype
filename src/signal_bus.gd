extends Node

# Signal bus for global events

@warning_ignore("unused_signal")
signal on_boss_health_changed(current_health: int)
@warning_ignore("unused_signal")
signal on_boss_died()
@warning_ignore("unused_signal")
signal on_player_health_changed(current_health: int)
@warning_ignore("unused_signal")
signal on_player_died()