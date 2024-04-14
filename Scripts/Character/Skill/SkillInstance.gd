class_name SkillInstance

var monitored_skill: SkillData
var current_upgrade_level: int
var is_unlocked: bool

func _init(skill: SkillData):
	monitored_skill = skill
	current_upgrade_level = 0
	is_unlocked = monitored_skill.is_unlocked_by_default
