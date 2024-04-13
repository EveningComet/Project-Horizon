## Responsible for managing the decisions for the enemy.
class_name EnemyTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	EventBus.side_finished_turn.connect( on_enemy_finished_turn )
	process_enemy_turn()
	if OS.is_debug_build() == true:
		print("EnemyTurn :: Entered.")

func exit() -> void:
	EventBus.side_finished_turn.disconnect( on_enemy_finished_turn )

func process_enemy_turn() -> void:
	var actions_to_send: Array[StoredAction] = []
	var enemies_to_process: Array[EnemyCombatant] = []
	var player_targets:     Array[PlayerCombatant] = []
	for com in my_state_machine.combatants:
		if com is EnemyCombatant:
			enemies_to_process.append( com )
		elif com is PlayerCombatant:
			player_targets.append(com)
	
	# TODO: Implement better enemies. For now, just have them attack the first
	# person in the player's party with enough hp
	for enemy: EnemyCombatant in enemies_to_process:
		var action: StoredAction = StoredAction.new()
		action.set_activator( enemy )
		for player_character: PlayerCombatant in player_targets:
			if player_character.stats[StatTypes.stat_types.CurrentHP] > 0:
				action.recipients.append( player_character )
				action.action_type = ActionTypes.ActionTypes.SingleEnemy
				actions_to_send.append( action )
				break
	
	EventBus.side_finished_turn.emit( actions_to_send )

func on_enemy_finished_turn(actions_to_send: Array[StoredAction]) -> void:
	my_state_machine.complete_player_turn( actions_to_send )
	my_state_machine.change_to_state("ResolveTurn")
