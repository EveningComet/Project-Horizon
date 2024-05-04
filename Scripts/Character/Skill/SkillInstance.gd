## Stores an instance of a skill.
class_name SkillInstance

## Notifiies about upgrades.
signal skill_upgraded(si: SkillInstance)

## Notifies about downgrades.
signal skill_downgraded(si: SkillInstance)

## Notifies things for whether or not the player is able to upgrade this skill.
signal skill_lock_status_changed()

var monitored_skill: SkillData
var branched_skills: Array[SkillInstance] = []
var unlocked_skills: Array[SkillInstance] = []
var current_upgrade_level: int = 0:
	get:
		return current_upgrade_level
	set(value):
		# Legalize the value
		current_upgrade_level = value
		if current_upgrade_level > monitored_skill.max_rank:
			current_upgrade_level = monitored_skill.max_rank

var is_unlocked: bool = false

func initialize(skill: SkillData) -> void:
	monitored_skill = skill
	
	# Check if this skill needs to be locked on creation
	
	# The character can use this skill right from the start
	if monitored_skill.is_unlocked_by_default == true:
		is_unlocked = true
		current_upgrade_level = 1
	
	# The skill is not usable from the start, but it doesn't need a previous
	# rank
	elif monitored_skill.is_unlocked_by_default == false and \
	monitored_skill.minimum_rank_of_previous < 1:
		is_unlocked = true
	
	# Create the branched skills
	for branch: SkillData in skill.branches:
		var new_branch = SkillInstance.new()
		new_branch.initialize(branch)
		branched_skills.append(new_branch)
		handle_unlock(current_upgrade_level)

func unlock() -> void:
	if is_unlocked == true:
		return
	is_unlocked = true
	skill_lock_status_changed.emit()

func relock() -> void:
	is_unlocked = false
	skill_lock_status_changed.emit()

func try_to_unlock_with_class_level(new_level: int) -> void:
	if new_level >= monitored_skill.unlocks_at_class_level:
		unlock()

func try_to_relock_with_class_level(new_level: int) -> void:
	if new_level < monitored_skill.unlocks_at_class_level:
		relock()

func upgrade_to_level(new_level: int) -> void:
	current_upgrade_level = new_level
	handle_unlock(current_upgrade_level)
	skill_upgraded.emit(self)

func handle_unlock(new_level: int) -> void:
	for branch in branched_skills:
		if branch.can_unlock_skill(new_level) == true and \
		unlocked_skills.has(branch) == false:
			branch.unlock()
			unlocked_skills.append(branch)

func downgrade(new_level: int) -> void:
	current_upgrade_level = new_level
	handle_relock()
	skill_downgraded.emit(self)

func handle_relock() -> void:
	for s in unlocked_skills:
		if s.can_unlock_skill(current_upgrade_level) == false:
			s.relock()
			unlocked_skills.erase(s)

func can_unlock_skill(new_level: int) -> bool:
	return new_level >= monitored_skill.minimum_rank_of_previous
