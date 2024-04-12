class_name SkillInstance

var monitored_skill: SkillData

var current_upgrade_level: int

func _init(skill: SkillData):
	monitored_skill = skill
	current_upgrade_level = 0
