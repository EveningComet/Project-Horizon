class_name MissionSelectButton extends Button

var mission: MissionData = null

func _init(_mission: MissionData, _is_unlocked: bool):
	mission = _mission
	text = mission.mission_name
	disabled = !_is_unlocked
