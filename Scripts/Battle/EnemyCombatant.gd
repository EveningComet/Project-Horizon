## Data for an enemy character.
class_name EnemyCombatant extends Combatant

var stored_enemy_data: EnemyData = null

## Is the regular attack ranged?
var is_regular_attack_ranged: bool = false

func initialize_with_enemy_data(enemy_data: EnemyData) -> void:
	# Cache this enemy
	stored_enemy_data = enemy_data
	
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		enemy_data.vitality,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		enemy_data.expertise,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		enemy_data.will,
		true
	)
	
	initialize_vitals()
	initialize_other_stats()
	
	for skill: SkillData in enemy_data.available_skills:
		var skill_instance = SkillInstance.new()
		skill_instance.monitored_skill = skill
		skill_holder.skill_data_instances[skill] = skill_instance

func initialize_vitals() -> void:
	var true_max_hp: Stat = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * VITALITY_HP_SCALER,
		true
	)
	var true_max_sp: Stat = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * WILL_SPECIAL_POINTS_SCALER,
		true
	)
	
	for mod: StatModifier in stored_enemy_data.stat_modifiers:
		if mod.stat_changing == StatTypes.stat_types.MaxHP:
			true_max_hp.add_modifier( mod )
		elif mod.stat_changing == StatTypes.stat_types.MaxSP:
			true_max_sp.add_modifier( mod )
	
	stats[StatTypes.stat_types.MaxHP]     = true_max_hp
	stats[StatTypes.stat_types.CurrentHP] = true_max_hp.get_calculated_value()
	stats[StatTypes.stat_types.MaxSP]     = true_max_sp
	stats[StatTypes.stat_types.CurrentSP] = true_max_sp.get_calculated_value()

func initialize_other_stats() -> void:
	super()
	for mod: StatModifier in stored_enemy_data.stat_modifiers:
		match mod.stat_changing:
			
			# Ignore the vital boosters
			StatTypes.stat_types.MaxHP, StatTypes.stat_types.MaxSP:
				continue
				
			# Everything else is fine
			_:
				add_modifier( mod.stat_changing, mod )
