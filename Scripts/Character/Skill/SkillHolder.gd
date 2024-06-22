## Stores a collection of instanced skills.
class_name SkillHolder extends Resource

## The combatant being kept track of.
var combatant: Combatant

## Dictionary { SkillInstance : Current Rank }
var skills: = {}

func _init(new_combatant: Combatant) -> void:
	combatant = new_combatant

## Return a list of all the stored skill instances.
func get_all_skills() -> Array[SkillInstance]:
	var all_skills: Array[SkillInstance] = []
	for instance: SkillInstance in skills.keys():
		all_skills.append(instance)
	return all_skills

## Return a list of skill instances that have a rank greater than 0.
func get_usable_skills() -> Array[SkillInstance]:
	var usable_skills: Array[SkillInstance] = []
	for instance in skills.keys():
		if instance.curr_rank > 0:
			usable_skills.append(instance)
	return usable_skills

## Add a collection of skills from a character class.
func add_character_class_skills(cd: CharacterClass) -> void:
	initialize_skill_instances(cd.skills)

func initialize_skill_instances(new_skills: Array[SkillData]) -> void:
	for sd: SkillData in new_skills:
		var skill_instance = SkillInstance.new(sd)
		skills[skill_instance] = skill_instance.curr_rank
		skill_instance.rank_changed.connect( on_skill_rank_changed )

func on_skill_rank_changed(changed_skill: SkillInstance) -> void:
	# Make the necessary stat changes
	var previous_rank: int = skills[changed_skill]
	var target_rank:   int = changed_skill.curr_rank
	var tiers: Array[SkillTier] = changed_skill.skill.tiers
	if target_rank > previous_rank:
		for i in range(0, target_rank):
			var tier: SkillTier = changed_skill.skill.tiers[i]
			if tier.stat_modifiers.size() > 0:
				for mod: StatModifier in tier.stat_modifiers:
					combatant.remove_modifier(mod.stat_changing, mod)
		
		# Apply the proper stat upgrade
		var curr_tier: SkillTier = changed_skill.skill.get_tier(target_rank)
		if curr_tier.stat_modifiers.size() > 0:
			for mod: StatModifier in curr_tier.stat_modifiers:
				combatant.add_modifier(mod.stat_changing, mod)
	
	elif target_rank < previous_rank:
		var total_tiers: int = changed_skill.skill.tiers.size()
		var i: int = total_tiers - 1
		while i >= target_rank:
			var tier: SkillTier = tiers[i]
			if tier.stat_modifiers.size() > 0:
				for mod: StatModifier in tier.stat_modifiers:
					combatant.remove_modifier(mod.stat_changing, mod)
			i -= 1
		
		# Apply the proper stat change
		
	skills[changed_skill] = target_rank
