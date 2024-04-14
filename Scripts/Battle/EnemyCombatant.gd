## Data for an enemy character.
class_name EnemyCombatant extends Combatant

var stored_enemy_data: EnemyData = null

## The experience points this enemy should give on death.
var experience_to_give_on_death: int = 15

# TODO: The Sprite/Portrait for this enemy.

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
	experience_to_give_on_death = enemy_data.exp_on_death
	initialize_vitals()
	initialize_other_stats()
	skill_holder.initialize( enemy_data.available_skills )

func initialize_vitals() -> void:
	super()
	# TODO: Here is where the enemy will be given extra bonus health, etc.

func initialize_other_stats() -> void:
	super()
	# TODO: This is where the enemy would get extra defense, speed, etc.
