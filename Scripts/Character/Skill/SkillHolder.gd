## Stores a collection of instanced skills.
class_name SkillHolder

## The combatant being kept track of.
var combatant: Combatant

## Dictionary { skill_data : skill_instance }
var skill_data_instances: = {}

func _init(new_combatant: Combatant) -> void:
	combatant = new_combatant

func initialize_for_player_character(skill_class: CharacterClass):
	initialize_skill_data_instances( skill_class.skills )
	try_to_unlock_with_class_level(skill_class, 1)

func add_skills(skills_to_add: Array[SkillData]) -> void:
	initialize_skill_data_instances(skills_to_add)

func add_from_character_class(cc: CharacterClass) -> void:
	initialize_skill_data_instances( cc.skills )
	try_to_unlock_with_class_level( cc, 1 )

## Return all the stored skills.
func skills() -> Array:
	var results: Array = []
	var visited: Dictionary = {}
	# Use dfs to go through the skills
	for skill_instance: SkillInstance in skill_data_instances.values():
		
		var stack: Array[SkillInstance] = []
		visited[skill_instance] = true
		stack.append(skill_instance)
		while stack.is_empty() == false:
			var current: SkillInstance = stack.pop_front()
			for neighbor in current.branched_skills:
				if visited.has(neighbor) == false:
					visited[neighbor] = true
					stack.append(visited)

	return visited.keys()

func get_usable_skills() -> Array:
	var result = []
	var visited: Array = skills()
	for v in visited:
		var skill_instance = v as SkillInstance
		if skill_instance.current_upgrade_level > 0:
			result.append(v)
	
	return result

## Mainly for player characters.
func try_to_unlock_with_class_level(cc: CharacterClass, level: int):
	for skill in skill_data_instances:
		# TODO: This does not take branching into account!
		if cc.skills.has(skill) == true:
			var skill_instance = skill_data_instances[skill]
			skill_instance.try_to_unlock_with_class_level( level )

func try_to_relock_with_class_level(cc: CharacterClass, level: int) -> void:
	for skill in skill_data_instances:
		# TODO: This does not take branching into account!
		if cc.skills.has(skill) == true:
			var skill_instance = skill_data_instances[skill]
			skill_instance.try_to_relock_with_class_level( level )

func initialize_skill_data_instances(skills: Array[SkillData]):
	for data in skills:
		var skill_instance: SkillInstance = SkillInstance.new()
		skill_instance.initialize( data )
		skill_data_instances[data] = skill_instance
		
		# Connect to the upgrades and downgrades
		skill_instance.skill_upgraded.connect( on_skill_upgraded )
		skill_instance.skill_downgraded.connect( on_skill_downgraded )

func on_skill_upgraded(instance: SkillInstance) -> void:
	# If the upgraded skill changes stats, handle that with the combatant
	# Remove all the lower tier upgrades
	var upgrade_level: int = instance.current_upgrade_level
	var tiers: Array[SkillTier] = instance.monitored_skill.tiers
	for i in range(0, upgrade_level):
		var tier: SkillTier = instance.monitored_skill.get_tier(i + 1)
		if tier.stat_modifiers.size() > 0:
			for mod: StatModifier in tier.stat_modifiers:
				combatant.remove_modifier(mod.stat_changing, mod)
	
	# Apply the proper stat upgrade
	var curr_tier: SkillTier = instance.monitored_skill.get_tier(upgrade_level)
	if curr_tier.stat_modifiers.size() > 0:
		for mod: StatModifier in curr_tier.stat_modifiers:
			combatant.add_modifier(mod.stat_changing, mod)

func on_skill_downgraded(instance: SkillInstance) -> void:
	# If the upgraded skill changes stats, handle that with the combatant
	# Remove any of the higher tiers
	var total_tiers: int = instance.monitored_skill.tiers.size()
	var tiers: Array[SkillTier] = instance.monitored_skill.tiers
	var i: int = tiers.size() - 1
	var downgraded_level: int = instance.current_upgrade_level
	while i >= downgraded_level:
		var tier: SkillTier = tiers[i]
		if tier.stat_modifiers.size() > 0:
			for mod: StatModifier in tier.stat_modifiers:
				combatant.remove_modifier(mod.stat_changing, mod)
		i -= 1
