## Stores data about a single encounter
class_name MissionData extends Resource

var enemy: EnemyData

func _init(_enemy: EnemyData):
	enemy = _enemy
