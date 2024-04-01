## Base class for characters that will be placed into combat.
class_name PlayerCombatant extends Combatant

## The name for this player character.
var char_name: String

## The class this character is.
var pc_class: CharacterClass # TODO: Implement multiclassing.

var curr_level:              int = 1
var curr_experience_points:  int = 0
var experience_required:     int = get_experience_required( curr_level )
var total_experience_points: int = 0

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
	
	# Vitals
	stats[StatTypes.stat_types.MaxHP] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * 3,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
	
	# Other stats
	stats[StatTypes.stat_types.Defense] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * 2,
		true
	)
	
	# TODO: Set the default skills, if any?

## Initialize the player character based on another player character.
func initialize_with_copy(copy: PlayerCombatant) -> void:
	char_name        = copy.char_name
	stats            = copy.stats
	available_skills = copy.available_skills

# TODO: Multiclassing.
func set_pc_class(new_class: CharacterClass) -> void:
	pc_class = new_class

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
	#experience_gained.emit( growth_data )

## Boost this character's level.
func level_up() -> void:
	
	# Boost the level and the required experience.
	curr_level += 1
	experience_required = get_experience_required( curr_level )
	
	# TODO: Give the character skill points/attribute points/ etc.