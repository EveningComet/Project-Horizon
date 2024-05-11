## A class responsible for passing around needed data to multiple objects that want to know
## the same thing.
extends Node

## Fired when a character has lost all their health.
signal hp_depleted(combatant: Combatant)

## Fired when a character is spawned into battle. Usually called at the start of
## a battle unless a character is spawned in through a skill.
signal combatant_spawned_in_battle(combatant: Combatant)

## Used to tell things that need to know about the battle being ready to commence.
signal battle_setup_finished

signal begin_player_turn

signal battle_ended

signal player_combatant_turn_started(combatant: Combatant)

## Used when the player or the enemy finishes their turn.
signal side_finished_turn(actions_to_send: Array[StoredAction])

signal tooltip_hide

@onready var tooltip_scene = preload("res://Scenes/UI/General/Tooltip.tscn")

## Fired when the player focuses/hovers over something that is associated
## with a tooltip.
func on_tooltip_needed(tooltip_data: Control) -> void:
	var tooltip: Tooltip = tooltip_scene.instantiate()
	
	# TODO: Figure out tooltip placement.
	var root = get_tree().root
	var size = root.get_child_count()
	root.get_child( size - 1).add_child(tooltip)
	tooltip.global_position = tooltip_data.global_position + Vector2(10, 10)
	
	tooltip_hide.connect( tooltip.on_tooltip_hide )
	tooltip.on_tooltip_display(tooltip_data)
