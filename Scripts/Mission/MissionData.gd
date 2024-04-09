## Stores data about a single battle
class_name MissionData extends Resource

var name: String
var enemies: Array[EnemyData]
var is_unlocked: bool

func _init(_name: String, _enemies: Array[EnemyData]):
	name = _name
	enemies = _enemies
	is_unlocked = false

func unlock() -> void:
	is_unlocked = true
