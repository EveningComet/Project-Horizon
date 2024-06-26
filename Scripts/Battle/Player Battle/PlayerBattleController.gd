## Responsible for managing all the things related to the player during a
## battle.
class_name PlayerBattleController extends StateMachine

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

func setup_for_new_turn() -> void:
	# Clear the previous data and enter the select action state for the first
	# character
	stored_actions.clear()
	
	# Get the current character's the player has and then make the player
	# start selecting actions for the first character in their party
	# TODO: Check for summons? Should really check for a variable or function maybe.
	for character: Combatant in spawned_combatants_node.get_children():
		
		# If the character is a player combatant and they have enough health,
		# then the player can select actions for that character
		if character is PlayerCombatant and character.stats[StatTypes.stat_types.CurrentHP] > 0:
			party_members_to_go_through.append( character )
			
	curr_combatant_idx = 0
	curr_combatant     = party_members_to_go_through[curr_combatant_idx]

## When the player has finally finished selecting actions for all their characters.
func clean_up_for_turn_end_and_return_stored_actions_as_list() -> Array[StoredAction]:
	party_members_to_go_through.clear()
	
	# Convert the stored actions to a list
	var actions_to_send: Array[StoredAction] = []
	for action in stored_actions:
		actions_to_send.append( stored_actions[action] )
	return actions_to_send

## Get the current combatant the player is selecting actions for.
func get_current_combatant() -> Combatant:
	return curr_combatant

func advance_to_next_character() -> void:
	curr_combatant_idx += 1
	curr_combatant      = party_members_to_go_through[curr_combatant_idx]

func return_to_previous_character() -> void:
	curr_combatant_idx -= 1
	curr_combatant_idx = max(curr_combatant_idx, 0)
	curr_combatant     = party_members_to_go_through[curr_combatant_idx]

## Returns true or false dependong on whether or not the player still has to
## select actions for their characters.
func has_finished_selecting_needed_actions() -> bool:
	return stored_actions.size() == party_members_to_go_through.size()
