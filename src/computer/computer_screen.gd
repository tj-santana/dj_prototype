extends Control
class_name ComputerScreen

signal request_screen_change(target_scene_uid: String)

func change_screen(target_scene_uid: String) -> void:
	request_screen_change.emit(target_scene_uid)
