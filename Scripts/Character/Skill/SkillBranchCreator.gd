class_name SkillBranchCreator

static func create(skill_data_instances: Dictionary, starting_skills: Array) -> Array[SkillBranch]:
	var result: Array[SkillBranch] = []
	for skill in starting_skills:
		result.append(create_branch(skill_data_instances, skill))
	return result

static func create_branch(skill_data_instances: Dictionary, start_skill: SkillData) -> SkillBranch:
	var branch = SkillBranch.new()
	var unlockables = []
	populate_unlockables(start_skill, unlockables)
	branch.starting_skill = skill_data_instances[start_skill]
	for unlockable_data in unlockables:
		branch.unlockables.append(skill_data_instances[unlockable_data])
	return branch

static func populate_unlockables(skill: SkillData, unlockables: Array):
	if (skill.unlockable.is_empty()):
		return
	unlockables.append_array(skill.unlockable)
	for next_skill in skill.unlockable:
		populate_unlockables(next_skill, unlockables)
