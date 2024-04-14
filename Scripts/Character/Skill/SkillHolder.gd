class_name SkillHolder

# Dictionary { skill_data : skill_instance }
var skill_data_instances: = {}

func initialize(skills_data: Array[SkillData]):
	for data in skills_data:
		skill_data_instances[data] = SkillInstance.new(data, on_new_skills_unlocked)

func skills() -> Array:
	return skill_data_instances.values()

func on_new_skills_unlocked(skill: SkillInstance, unlocked: Array[SkillData]):
	for data in unlocked:
		if (skill_data_instances.has(data)):
			skill_data_instances[data].unlock()
