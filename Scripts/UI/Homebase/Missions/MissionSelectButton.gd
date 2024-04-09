class_name MissionSelectButton extends Button

var mission: MissionData = null

func _init(_mission: MissionData):
	mission = _mission
	text = mission.name
	disabled = !mission.is_unlocked
