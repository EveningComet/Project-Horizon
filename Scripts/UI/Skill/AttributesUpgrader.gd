## Interface for spending attribute points and skill points
class_name AttributesUpgrader
extends Node

signal stats_changed(new_stats: Dictionary)

var stats: Dictionary = {}
var draft_stats: Dictionary = {} 
var minimum_for_attribute_downgrade: Dictionary = {}
var attributes := StatTypes.new().attributes()

func initialize(_character_changed: Signal):
	_character_changed.connect( store_stats )

func store_stats(character: PlayerCombatant):
	stats = character.stats
	reset_draft_and_minimum_stats()

func confirm():
	for attribute in attributes:
		stats[attribute].set_base_value( draft_stats[attribute] )
	reset_draft_and_minimum_stats()

func attribute_upgrade(attribute: StatTypes.stat_types):
	draft_stats[attribute] += 1
	emit_signal( "stats_changed", draft_stats )

func attribute_downgrade(attribute: StatTypes.stat_types):
	draft_stats[attribute] -= 1
	emit_signal( "stats_changed", draft_stats )

func class_upgrade(amount: Dictionary):
	for attribute in attributes:
		draft_stats[attribute] += amount[attribute]
		# We just did a class upgrade, so don't allow attribute downgrade to revert this.
		minimum_for_attribute_downgrade[attribute] = draft_stats[attribute]
	emit_signal( "stats_changed", draft_stats )

func undo_class_upgrade():
	reset_draft_and_minimum_stats()

func can_do_attribute_downgrade(attribute: StatTypes.stat_types) -> bool:
	return draft_stats[attribute] > minimum_for_attribute_downgrade[attribute]

func get_draft_stats(attribute: StatTypes.stat_types) -> int:
	return draft_stats[attribute]

func reset_draft_and_minimum_stats():
	for attribute in attributes:
		draft_stats[attribute] = stats[attribute].get_base_value()
		minimum_for_attribute_downgrade[attribute] = stats[attribute].get_base_value()
	emit_signal( "stats_changed", draft_stats )
