## Stores data about an enemy in a mission with randomized stats for now 
class_name EnemyData extends Resource

var vitality:  int
var expertise: int
var will:      int

func _init():
	vitality = randi_range( 3, 9 )
	expertise = randi_range( 3, 9 )
	will = randi_range( 3, 9 )
