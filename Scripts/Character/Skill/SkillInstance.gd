## Stores an instance of a skill.
class_name SkillInstance

var monitored_skill: SkillData
var branched_skills: Array[SkillInstance] = []
var unlocked_skills: Array[SkillData]
var current_upgrade_level: int = 0:
	get:
		return current_upgrade_level
	set(value):
		# Legalize the value
		current_upgrade_level = value
		if current_upgrade_level > monitored_skill.max_rank:
			current_upgrade_level = monitored_skill.max_rank

func initialize(skill: SkillData):
	monitored_skill = skill
	if monitored_skill.is_unlocked_by_default == true:
		current_upgrade_level = 1
	
	# Create the branched skills
	for branch: SkillData in skill.branches:
		var new_branch = SkillInstance.new()
		new_branch.initialize(branch)
		branched_skills.append(new_branch)

func upgrade_to_level(new_level: int):
	current_upgrade_level = new_level

func can_unlock_skill(skill: SkillData):
	return current_upgrade_level >= skill.minimum_rank_of_previous
