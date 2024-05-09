class_name MissionData extends Resource

@export var mission_name: String = "Operation Rainfall"

@export_multiline var mission_description: String = "Cool flavor text."

@export var enemies: Array[EnemyData] = []

@export var next_mission: MissionData

@export var is_unlocked_by_default: bool

@export var money_on_victory: int = 50
