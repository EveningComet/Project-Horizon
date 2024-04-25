class_name SkillBranchCreator

static func create(skill_data_instances: Dictionary, starting_skills: Array) -> Array[SkillBranch]:
	var result: Array[SkillBranch] = []
	var handed_skills: Array[SkillInstance] = []
	for skill in starting_skills:
		var branch := create_branch( skill_data_instances, skill )
		handed_skills.append_array( branch.skills )
		result.append( branch )
	result.append( create_standalone_branch(skill_data_instances, handed_skills) )
	result.sort_custom( func(a, b): return len( a.skills ) < len( b.skills ) )
	return result

static func create_branch(skill_data_instances: Dictionary, start_skill: SkillData) -> SkillBranch:
	var branch = SkillBranch.new()
	var unlockables = []
	populate_unlockables( start_skill, unlockables )
	branch.skills.append( skill_data_instances[start_skill] )
	for unlockable_data in unlockables:
		branch.skills.append( skill_data_instances[unlockable_data] )
	return branch

static func create_standalone_branch(skill_data_instances: Dictionary, handed_skills: Array) -> SkillBranch:
	var branch = SkillBranch.new()
	for skill_instance in skill_data_instances.values():
		if (not skill_instance in handed_skills):
			branch.skills.append(skill_instance)
	return branch

static func populate_unlockables(skill: SkillData, unlockables: Array):
	if (skill.unlockable.is_empty()):
		return
	unlockables.append_array( skill.unlockable )
	for next_skill in skill.unlockable:
		populate_unlockables( next_skill, unlockables )
