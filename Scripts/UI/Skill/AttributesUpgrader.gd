## Interface for spending attribute points and skill points
class_name AttributesUpgrader
extends Node

signal attribute_upgraded
signal class_upgraded

signal stats_confirmed
signal stats_undone
signal stats_changed(new_stats: Dictionary)

var stats: Dictionary = {}
var draft_stats: Dictionary = {} 
var attributes := StatTypes.new().attributes()

func initialize(_character_changed: Signal):
	_character_changed.connect( store_stats )

func store_stats(character: PlayerCombatant):
	stats = character.stats
	reset_draft_stats()

func confirm():
	for attribute in attributes:
		stats[attribute].set_base_value( draft_stats[attribute] )
	reset_draft_stats()
	emit_signal( "stats_confirmed" )

func undo():
	reset_draft_stats()
	emit_signal( "stats_undone" )

func attribute_upgrade(attribute: StatTypes.stat_types):
	draft_stats[attribute] += 1
	emit_signal( "attribute_upgraded" )
	emit_signal( "stats_changed", draft_stats )

func class_upgrade(amount: Dictionary):
	for attribute in attributes:
		draft_stats[attribute] += amount[attribute]
	emit_signal( "class_upgraded" )
	emit_signal( "stats_changed", draft_stats )

func reset_draft_stats():
	for attribute in attributes:
		draft_stats[attribute] = stats[attribute].get_base_value()
	emit_signal( "stats_changed", draft_stats )

func get_draft_stats(attribute: StatTypes.stat_types) -> int:
	return draft_stats[attribute]
