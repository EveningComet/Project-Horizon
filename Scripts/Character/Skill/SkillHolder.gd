class_name SkillHolder

# Dictionary { skill_data : skill_instance }
var skill_data_instances: = {}

var skill_branches: Array[SkillBranch] = []

func initialize(skill_class: CharacterClass, class_upgraded: Signal):
	initialize_skill_data_instances(skill_class)
	unlock_and_upgrade_starting_skills()
	skill_branches = SkillBranchCreator.create( skill_data_instances, starting_skills() )
	class_upgraded.connect( try_unlock_upgraded_class_skills )

func skills() -> Array:
	return skill_data_instances.values()

func usable_skills() -> Array:
	var result = []
	for skill_instance in skill_data_instances.values():
		if (skill_instance.is_unlocked and skill_instance.current_upgrade_level > 0):
			result.append(skill_instance)
	return result

func starting_skills() -> Array:
	var result = []
	for data in skill_data_instances.keys():
		if (data.is_unlocked_by_default):
			result.append( data )
	return result

func on_new_skills_unlocked(unlocked: Array[SkillData]):
	for data in unlocked:
		if (skill_data_instances.has(data)):
			skill_data_instances[data].unlock()

func try_unlock_upgraded_class_skills(_class: CharacterClass, level: int):
	for skill in skill_data_instances.values():
		skill.try_unlock_with_class_levels(_class, level)

func initialize_skill_data_instances(skill_class: CharacterClass):
	for data in skill_class.skills:
		skill_data_instances[data] = SkillInstance.new()
		skill_data_instances[data].initialize(data, skill_class, on_new_skills_unlocked)

func unlock_and_upgrade_starting_skills():
	for data in starting_skills():
		skill_data_instances[data].unlock()	
		skill_data_instances[data].upgrade_to_level( 1 )	
