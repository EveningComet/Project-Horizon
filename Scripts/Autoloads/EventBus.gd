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

## Used when the player or the enemy finishes their turn.
signal side_finished_turn(actions_to_send: Array[StoredAction])

signal battle_ended
