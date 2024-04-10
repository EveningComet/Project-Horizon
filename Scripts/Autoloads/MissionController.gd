extends Node

var current_mission: MissionData = null
var unlocked_missions: Array[MissionData] = []

func select_mission(mission: MissionData) -> void:
	current_mission = mission

## The player has completed the current mission, so if there is a new one.
func unlock_next_mission(mission: MissionData) -> void:
	if mission.next_mission != null and unlocked_missions.has(mission.next_mission) == false:
		unlocked_missions.append(mission.next_mission)

func number_of_missions_completed() -> int:
	return len(unlocked_missions)

func is_mission_unlocked(mission: MissionData) -> bool:
	return mission.is_unlocked_by_default or mission in unlocked_missions
