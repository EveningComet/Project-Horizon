extends Node

signal level_changed(new_level)

var current_level: int = 1
	
func has_prev_level() -> bool:
	return current_level - 1 >= MissionConfiguration.missions_per_level.keys().min()

func has_next_level() -> bool:
	return current_level + 1 <= MissionConfiguration.missions_per_level.keys().max()

func get_current_level() -> int:
	return current_level

func get_available_missions() -> Array:
	if MissionConfiguration.missions_per_level.has(current_level):
		return MissionConfiguration.missions_per_level[get_current_level()]
	return []

func level_up() -> void:
	set_level(current_level + 1)

func level_down() -> void:
	set_level(current_level - 1)

func set_level(new_level: int) -> void:
	if (current_level != new_level):
		current_level = new_level
		level_changed.emit(current_level)
	
