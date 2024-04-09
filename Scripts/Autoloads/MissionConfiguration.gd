extends Node

var missions_per_level : Dictionary = {
	1 : [
		MissionData.new(EnemyData.new("Enemy 1")),
		MissionData.new(EnemyData.new("Enemy 2")),
		MissionData.new(EnemyData.new("Enemy 3")),
	],
	2 : [
		MissionData.new(EnemyData.new("Enemy A")),
		MissionData.new(EnemyData.new("Enemy B")),
	]
}
	
