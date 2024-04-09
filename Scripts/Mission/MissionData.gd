## Stores data about a single battle
class_name MissionData extends Resource

var enemy: EnemyData

func _init(_enemy: EnemyData):
	enemy = _enemy
