## Base class for characters that will be placed into combat.
class_name PlayerCombatant extends Combatant

## Fired when the character gets experience points.
signal experience_gained(growth_data: Array)

## The name for this player character.
var char_name: String

## The classes of this character
## Dictionary { class, current_level }
var pc_classes: Dictionary = {}

var curr_level:              int = 1
var curr_experience_points:  int = 0
var experience_required:     int = get_experience_required( curr_level )
var total_experience_points: int = 0

## The points for boosting one of this character's skills or class levels.
var available_skill_points:     int = 0

## The points for boosting one of the three core attributes.
var available_attribute_points: int = 0

## When a character levels up, this dictates the scale for how many experience
## points are required for the next level up.
const EXPERIENCE_GROWTH_PERCENTAGE: float = 1.10

func set_char_name(text: String) -> void:
	char_name = text

## Initialize the starting stats based on the passed class data.
func initialize_with_class_data(class_data: CharacterClass) -> void:
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		class_data.starting_vitality,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		class_data.starting_expertise,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		class_data.starting_will,
		true
	)
	
	initialize_vitals()
	initialize_other_stats()
	
	# Setup the relevant skills
	skill_holder.initialize(class_data, stat_changed)

# TODO: Multiclassing.
func set_pc_class(new_class: CharacterClass) -> void:
	pc_classes[new_class] = new_class.STARTING_LEVEL
	initialize_with_class_data( new_class )

# TODO: Removed when multiclassing is implemented.
func pc_class() -> CharacterClass:
	return pc_classes.keys()[0]

## Return how much experience is required for this character to level up.
## Calculation is: 100 * (growth_percent^( current level - 1))
func get_experience_required(level: int) -> int:
	return round( 100 * pow(EXPERIENCE_GROWTH_PERCENTAGE, level - 1) )

## Give this character experience points.
func gain_experience(gain_amount: int) -> void:
	total_experience_points += gain_amount
	curr_experience_points += gain_amount
	var growth_data: Array = []
	
	# While the experience is high enough, keep leveling up.
	while curr_experience_points >= experience_required:
		curr_experience_points -= experience_required
		growth_data.append( [experience_required, experience_required] )
		level_up()
	growth_data.append( [curr_experience_points, experience_required] )
	
	# Notify anything about the change in experience
	experience_gained.emit( growth_data )

## Boost this character's level.
func level_up() -> void:
	
	# Boost the level and the required experience for the next level
	curr_level += 1
	experience_required = get_experience_required( curr_level )
	
	# Give the character skill points/attribute points/etc.
	available_attribute_points += 1
	available_skill_points     += 3

func get_attributes_increase() -> Dictionary:
	return {
		StatTypes.stat_types.Vitality : pc_class().vitality_on_increase,
		StatTypes.stat_types.Expertise : pc_class().expertise_on_increase,
		StatTypes.stat_types.Will : pc_class().will_on_increase,
	}
