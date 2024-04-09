extends Node

signal level_changed(new_level)

const MIN_LEVELS: int = 1
const MAX_LEVELS: int = 10

var current_level: int = 1
var missions_per_level: Dictionary = {}

func _ready():
	for i in range(MIN_LEVELS, MAX_LEVELS + 1):
		missions_per_level[i] = []
	#TODO: some factory lgoic here for levels
	missions_per_level[1] = [
		MissionData.new(EnemyData.new("Enemy 1")),
		MissionData.new(EnemyData.new("Enemy 2")),
		MissionData.new(EnemyData.new("Enemy 3")),
	]
	missions_per_level[2] = [
		MissionData.new(EnemyData.new("Enemy A")),
		MissionData.new(EnemyData.new("Enemy B")),
	]
	
func has_prev_level() -> bool:
	return current_level - 1 >= MIN_LEVELS

func has_next_level() -> bool:
	return current_level + 1 <= MAX_LEVELS

func get_current_level() -> int:
	return current_level

func get_available_missions() -> Array:
	return missions_per_level[get_current_level()]

func level_up() -> void:
	set_level(current_level + 1)

func level_down() -> void:
	set_level(current_level - 1)

func set_level(new_level: int) -> void:
	if (current_level != new_level):
		current_level = new_level
		level_changed.emit(current_level)
