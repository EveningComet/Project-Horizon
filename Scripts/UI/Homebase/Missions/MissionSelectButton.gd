## Allows an accessible way to go on a mission.
class_name MissionSelectButton extends Button

var mission: MissionData = null

func setup(_mission: MissionData, _is_unlocked: bool):
	mission = _mission
	text = mission.mission_name
	disabled = !_is_unlocked
