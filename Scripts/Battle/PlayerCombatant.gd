## Base class for characters that will be placed into combat.
class_name PlayerCombatant extends Combatant

## Fired when the character gets experience points.
signal experience_gained(growth_data: Array)

## Fired when a class gets upgraded
signal class_upgraded(pc_class: CharacterClass, new_class: int)

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
var available_skill_points:     int = 5

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
	status_effect_holder.initialize(self)
	initialize_vitals()
	initialize_other_stats()
	
	# Setup the relevant skills
	skill_holder.initialize_for_player_character(class_data)

## Add a character class to the player character. The first one will be the
## "starting" class.
func set_pc_class(new_class: CharacterClass) -> void:
	pc_classes[new_class] = new_class.STARTING_LEVEL
	if pc_classes.size() == 1:
		initialize_with_class_data( new_class )
	else:
		skill_holder.add_from_character_class( new_class )

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

func upgrade_class_to_level(_class: CharacterClass, level: int):
	if (level != pc_classes[_class]):
		pc_classes[_class] = level
		stat_changed.emit( self )
		emit_signal( "class_upgraded", _class, level )

## Upgrade the passed class by the amount.
func upgrade_class_by(_class: CharacterClass, additional_class_levels: int) -> void:
	pc_classes[_class] += additional_class_levels
	stat_changed.emit( self )
	emit_signal( "class_upgraded", _class, pc_classes[_class] )

## Upgrades the class and internally handles boosting the stats.
func upgrade_class_and_self_handle_upgrades(
		_class: CharacterClass, additional_class_levels: int
	) -> void:
	for i in additional_class_levels:
		for attribute in get_attributes_increase_for_class(_class):
			raise_base_value_by(
				attribute,
				get_attributes_increase_for_class(_class)[attribute]
			)
	pc_classes[_class] += additional_class_levels
	stat_changed.emit( self )
	emit_signal( "class_upgraded", _class, pc_classes[_class] )

func get_classes_as_array() -> Array:
	return pc_classes.keys()

func get_attributes_increase_for_class(cc: CharacterClass) -> Dictionary:
	var classes_as_array = get_classes_as_array()
	var index: int = classes_as_array.find(cc)
	var dc: CharacterClass = classes_as_array[index]
	return {
		StatTypes.stat_types.Vitality  : dc.vitality_on_increase,
		StatTypes.stat_types.Expertise : dc.expertise_on_increase,
		StatTypes.stat_types.Will      : dc.will_on_increase
	}

func take_damage(action_mediator: ActionMediator) -> void:
	super(action_mediator)
	
	# Don't allow the hp to be displayed below zero
	if get_current_hp() < 0:
		stats[StatTypes.stat_types.CurrentHP] = 0
		stat_changed.emit( self )
