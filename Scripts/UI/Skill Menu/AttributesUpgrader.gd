## Interface for spending attribute points and skill points
class_name AttributesUpgrader
extends Node

signal attribute_upgraded
signal class_upgraded

signal stats_confirmed
signal stats_undone
signal stats_changed(new_stats: Dictionary)

var character: PlayerCombatant
var current_class: CharacterClass

## Stores the classes and their potentially new levels.
var classes_and_class_levels: Dictionary

## Stores what the player's attributes will be depending on the upgrades.
var draft_stats: Dictionary = {}
var attributes := StatTypes.new().attributes()

func initialize(_character_changed: Signal, _class_changed: Signal):
	_class_changed.connect( set_class )
	_character_changed.connect( store_stats )

func set_class(_new_class: CharacterClass):
	current_class = _new_class
	reset_draft_stats()

func store_stats(_character: PlayerCombatant):
	character = _character
	classes_and_class_levels = character.pc_classes.duplicate()
	reset_draft_stats()

func confirm():
	
	# Upgrade the class level
	for key: CharacterClass in classes_and_class_levels:
		var diff: int = classes_and_class_levels[key] - character.pc_classes[key]
		if diff > 0:
			character.upgrade_class_by(key, diff)
	
	# Upgrade the attributes
	for attribute in attributes:
		var draft_val:    int = draft_stats[attribute]
		var original_val: int = character.stats[attribute].get_base_value()
		var diff:         int = draft_val - original_val
		if diff > 0:
			character.raise_base_value_by(attribute, diff)
	
	reset_draft_stats()
	emit_signal( "stats_confirmed" )

func undo():
	reset_draft_stats()
	emit_signal( "stats_undone" )

func attribute_upgrade(attribute: StatTypes.stat_types):
	draft_stats[attribute] += 1
	emit_signal( "attribute_upgraded" )
	emit_signal( "stats_changed", draft_stats )

func class_upgrade(upgrading_class: CharacterClass):
	classes_and_class_levels[upgrading_class] += 1
	for attribute in attributes:
		draft_stats[attribute] += upgrading_class.get_upgrade_attributes()[attribute]
	
	# The class is being upgraded, see if there are any skills that can be
	# unlocked for that class
	character.skill_holder.try_to_unlock_with_class_level(
		current_class, classes_and_class_levels[upgrading_class]
	)
	
	emit_signal( "class_upgraded" )
	emit_signal( "stats_changed", draft_stats )

func reset_draft_stats():
	if current_class != null and character != null and character.pc_classes.has(current_class):
		classes_and_class_levels[current_class] = character.pc_classes[current_class]
		for attribute in attributes:
			draft_stats[attribute] = character.stats[attribute].get_base_value()
		
		# See if some skills have to be relocked
		character.skill_holder.try_to_relock_with_class_level(
			current_class, character.pc_classes[current_class]
		)
		
		emit_signal( "stats_changed", draft_stats )
