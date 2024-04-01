## Responsible for managing all the things related to the player during a
## battle.
class_name PlayerBattleController extends StateMachine

## A reference to the battle manager so that it is easy to pass along
## needed data.
@export var battle_manager: BattleManager

## The node that displays the actions a player's character can perform.
@export var player_action_commands: PlayerActionCommands

## Node responsible for holding the data side of the player's characters.
@export var spawned_combatants_node: Node

## The player's currently controlled characters.
var party_members_to_go_through: Array[Combatant] = []

var curr_combatant_idx: int = 0

## The current combatant the character is deciding an action for.
var curr_combatant: Combatant

## Stores the selected actions for characters in a key value pair.
## The character will be the key, their action will be the value.
var stored_actions:   Dictionary = {}

## Stores the previously selected action for each character for convenience.
var previous_actions: Dictionary = {}

func set_me_up() -> void:
	player_action_commands.close()
	battle_manager.player_turn_started.connect( on_player_turn_started )
	super()

func _unhandled_input(event: InputEvent) -> void:
	curr_state.check_for_unhandled_input( event )

func get_pac() -> PlayerActionCommands:
	return player_action_commands

## Store the action and the combatant so that it may passed later on to the
## battle controller.
func store_action(combatant: Combatant, action_to_store: StoredAction) -> void:
	previous_actions[combatant]    = combatant
	stored_actions[combatant] = action_to_store

func on_player_turn_started() -> void:
	# Clear the previous data and enter the select action state for the first
	# character
	stored_actions.clear()
	
	# Get the current character's the player has and then make the player
	# start selecting actions for the first character in their party
	# TODO: Check for summons? Should really check for a variable or function maybe.
	for character in spawned_combatants_node.get_children():
		if character is PlayerCombatant:
			party_members_to_go_through.append( character )
			
	curr_combatant_idx = 0
	curr_combatant     = party_members_to_go_through[curr_combatant_idx]
	change_to_state("PBSelectAction")

## When the player has finally finished selecting actions for all their characters.
func player_turn_ended() -> void:
	party_members_to_go_through.clear()
	
	# Convert the stored actions to a list
	var actions_to_send: Array[StoredAction] = []
	for action in stored_actions:
		actions_to_send.append( stored_actions[action] )
	
	battle_manager.complete_player_turn( actions_to_send )
	change_to_state("PBIdle")

## Get the current combatant the player is selecting actions for.
func get_current_combatant() -> Combatant:
	return curr_combatant

func advance_to_next_character() -> void:
	curr_combatant_idx += 1
	curr_combatant      = party_members_to_go_through[curr_combatant_idx]

func return_to_previous_character() -> void:
	pass

## Returns true or false dependong on whether or not the player still has to
## select actions for their characters.
func has_finished_selecting_needed_actions() -> bool:
	if stored_actions.size() == party_members_to_go_through.size():
		return true
	else:
		return false
