## Responsible for deciding what enemies should do.
class_name EnemyDecisionHandler extends Node

func handle_enemy_turn(
	enemies: Array[EnemyCombatant],
	player_party: Array[PlayerCombatant]
) -> void:
	
	# The actions that will be sent
	var actions_to_send: Array[StoredAction] = []
	
	# TODO: Testing. Implement the handling of more than one enemy and more than one behavior.
	var enemy: EnemyCombatant = enemies[0]
	var behavior = enemy.stored_enemy_data.possible_decisions[0]
	var choices_for_current_enemy: Array[UtilityAIOption] = []
	if OS.is_debug_build() == true:
		print("EnemyDecisionHandler :: Handling the behavior (%s) for: %s" % [behavior.name, enemy.stored_enemy_data.enemy_name])
	
	for player_com: PlayerCombatant in player_party:
		
		# Action the current enemy could perform
		var potential_action: StoredAction = StoredAction.new()
		potential_action.activator = enemy
		potential_action.action_type = ActionTypes.ActionTypes.SingleEnemy
		potential_action.skill_instance = null # TODO: Every enemy will need a generic attack action.
		potential_action.recipients = []
		potential_action.recipients.append( player_com )
		
		# Generate the context for the AI to use
		var curr_target_stats: Dictionary = player_com.stats
		var context: Dictionary = {
			"curr_hp": curr_target_stats[StatTypes.stat_types.CurrentHP],
			"base_defense": player_com.get_defense(),
			"potential_damage": enemy.get_physical_power() - player_com.get_defense()
		}   # TODO: For potential damage, check if using regular or special damage.
		
		# Get the choice
		var choice = UtilityAIOption.new(behavior, context, potential_action)
		choices_for_current_enemy.append( choice )
	
	# Find the best action for the enemy to use
	var decision = UtilityAI.choose_highest( choices_for_current_enemy )
	if OS.is_debug_build() == true:
		print("EnemyDecisionHandler :: Best decision: ", decision)
		print("EnemyDecisionHandler :: %s is going to be attacked!" % [decision.action.recipients[0].char_name])
	
	# Add the action to our list of things to send
	actions_to_send.append( decision.action as StoredAction )
	EventBus.side_finished_turn.emit( actions_to_send )
