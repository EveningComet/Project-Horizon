## Stores a collection of instanced skills.
class_name SkillHolder

## Dictionary { skill_data : skill_instance }
var skill_data_instances: = {}

func initialize_for_player_character(skill_class: CharacterClass):
	initialize_skill_data_instances( skill_class.skills )

func add_skills(skills_to_add: Array[SkillData]) -> void:
	initialize_skill_data_instances(skills_to_add)

## Return all the stored skills.
func skills() -> Array:
	return skill_data_instances.values()

func get_usable_skills() -> Array:
	var result = []
	for skill_instance in skill_data_instances.values():
		if skill_instance.current_upgrade_level > 0:
			result.append( skill_instance )
	return result

func on_new_skills_unlocked(unlocked: Array[SkillData]):
	for data in unlocked:
		if skill_data_instances.has( data ):
			skill_data_instances[data].unlock()

## Mainly for player characters.
func try_to_unlock_with_class_level(level: int):
	for skill in skill_data_instances.values():
		skill.try_to_unlock_with_class_level( level )

func initialize_skill_data_instances(skills: Array[SkillData]):
	for data in skills:
		skill_data_instances[data] = SkillInstance.new()
		skill_data_instances[data].initialize( data )
