## Stores data about a single battle
class_name MissionData extends Resource

var name: String
var enemy: Array[EnemyCombatant]

func _init(_name: String):
	name = _name  
