## Stores data about a single battle
class_name MissionData extends Resource

var name: String
var enemies: Array[EnemyData]
var is_unlocked: bool

func _init(_name: String, _enemies: Array[EnemyData], _is_unlocked: bool=false):
	name = _name
	enemies = _enemies
	is_unlocked = _is_unlocked

func unlock() -> void:
	is_unlocked = true
