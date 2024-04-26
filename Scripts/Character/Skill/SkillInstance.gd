class_name SkillInstance

const NO_LEVEL := -1
const STARTING_LEVEL := 0

var monitored_skill: SkillData
var skill_class: CharacterClass
var unlocked_skills: Array[SkillData]
var current_upgrade_level: int

var on_this_skill_unlocked: Callable
var on_new_skills_unlocked: Callable

func initialize(skill: SkillData, _skill_class: CharacterClass, _on_new_skills_unlocked: Callable):
	monitored_skill = skill
	skill_class = _skill_class
	unlocked_skills = []
	current_upgrade_level = NO_LEVEL
	on_new_skills_unlocked = _on_new_skills_unlocked

func subscribe_skill_unlocked(callback: Callable):
	on_this_skill_unlocked = callback

func upgrade_to_level(new_level: int):
	current_upgrade_level = new_level
	var new_skills := get_new_unlocked_skills()
	unlocked_skills.append_array( new_skills )
	if (not new_skills.is_empty()):
		on_new_skills_unlocked.call( new_skills )

func try_unlock_with_class_levels(_class: CharacterClass, level: int):
	if (skill_class == _class and level >= monitored_skill.unlocks_at_class_level):
		unlock()

func unlock():
	if (not is_unlocked()):
		current_upgrade_level = STARTING_LEVEL
		if (not on_this_skill_unlocked.is_null()):
			on_this_skill_unlocked.call()

func is_unlocked() -> bool:
	return monitored_skill.is_unlocked_by_default or current_upgrade_level >= STARTING_LEVEL

func is_usable() -> bool:
	return is_unlocked() and current_upgrade_level > STARTING_LEVEL

func get_new_unlocked_skills() -> Array[SkillData]:
	var new_skills: Array[SkillData] = []
	for skill in monitored_skill.unlockable:
		if (not skill_already_unlocked( skill ) and can_unlock_skill( skill )):
			new_skills.append( skill )
	return new_skills

func can_unlock_skill(skill: SkillData):
	return current_upgrade_level >= skill.minimum_rank_of_previous

func skill_already_unlocked(skill: SkillData):
	return unlocked_skills.has( skill )
