class_name SkillInstance

var monitored_skill: SkillData
var unlocked_skills: Array[SkillData]

var is_unlocked: bool
var current_upgrade_level: int

var on_this_skill_unlocked: Callable
var on_new_skills_unlocked: Callable

func _init(skill: SkillData, _on_new_skills_unlocked: Callable):
	monitored_skill = skill
	unlocked_skills = []
	current_upgrade_level = 0
	is_unlocked = monitored_skill.is_unlocked_by_default
	on_new_skills_unlocked = _on_new_skills_unlocked

func subscribe_skill_unlocked(callback: Callable):
	on_this_skill_unlocked = callback

func upgrade_to_level(new_level: int):
	current_upgrade_level = new_level
	var new_skills := get_new_unlocked_skills()
	if (not new_skills.is_empty()):
		on_new_skills_unlocked.call(self, new_skills)

func unlock():
	is_unlocked = true
	if (not on_this_skill_unlocked.is_null()):
		on_this_skill_unlocked.call()

func get_new_unlocked_skills() -> Array[SkillData]:
	var new_skills: Array[SkillData] = []
	for skill in monitored_skill.unlockable:
		var can_unlock := current_upgrade_level >= skill.minimum_rank_of_previous
		if (can_unlock and not unlocked_skills.has(skill)):
			new_skills.append(skill)
	return new_skills
