## Data for an enemy character.
class_name EnemyCombatant extends Combatant

@export_category("Enemy Data")
## How physically capable this enemy is. 
@export var vitality:  int = 5
## The expertise for this enemy.
@export var expertise: int = 5
## The will for this enemy.
@export var will:      int = 5

## The experience points this enemy should give on death.
@export var experience_to_give_on_death: int = 15

# TODO: Give bonus stats like max hp to enemies.
# TODO: The Sprite/Portrait for this enemy.

## Is the regular attack ranged?
@export var is_regular_attack_ranged: bool = false

func _ready() -> void:
	initialize()

func initialize() -> void:
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		vitality,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		expertise,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		will,
		true
	)
	
	initialize_vitals()
	initialize_other_stats()
