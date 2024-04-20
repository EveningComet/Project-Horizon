## Interface for spending attribute points and skill points
class_name AttributesUpgrader
extends Node

signal stats_changed(new_stats: Dictionary)
signal stats_confirmed(new_stats: Dictionary)

var stats: Dictionary = {} # { attribute: stat }
var draft_stats: Dictionary = {} # { attribute: base_value }
var attributes := StatTypes.new().attributes()

func initialize(_character_changed: Signal):
	_character_changed.connect( store_stats )

func store_stats(character: PlayerCombatant):
	stats = character.stats
	for attribute in attributes:
		draft_stats[attribute] = stats[attribute].get_base_value()
	emit_signal( "stats_changed", draft_stats )

func confirm():
	for attribute in attributes:
		stats[attribute].set_base_value(draft_stats[attribute])
	emit_signal("stats_confirmed", draft_stats)

func upgrade(attribute: StatTypes.stat_types):
	set_draft_stat_for_attribute(attribute, draft_stats[attribute] + 1)

func downgrade(attribute: StatTypes.stat_types):	
	set_draft_stat_for_attribute(attribute, draft_stats[attribute] - 1)

func is_minimum_reached(attribute: StatTypes.stat_types) -> bool:
	return draft_stats[attribute] <= stats[attribute].get_base_value()

func get_draft_stats(attribute: StatTypes.stat_types) -> int:
	return draft_stats[attribute]

func set_draft_stat_for_attribute(attribute: StatTypes.stat_types, base_value: int):
	draft_stats[attribute] = base_value
	emit_signal( "stats_changed", draft_stats )
