class_name SkillHolder

var skills: Array[SkillInstance] = []

func initialize(skills_data: Array[SkillData]):
	for data in skills_data:
		skills.append(SkillInstance.new(data))
