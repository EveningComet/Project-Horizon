## Responsible for managing the decisions for the enemy.
class_name EnemyTurn extends BattleState

@export var enemy_decision_handler: EnemyDecisionHandler

func enter(msgs: Dictionary = {}) -> void:
	EventBus.side_finished_turn.connect( on_enemy_finished_turn )
	process_enemy_turn()
	if OS.is_debug_build() == true:
		print("EnemyTurn :: Entered.")

func exit() -> void:
	EventBus.side_finished_turn.disconnect( on_enemy_finished_turn )

func process_enemy_turn() -> void:
	var enemies_to_process: Array[EnemyCombatant] = []
	var player_targets:     Array[PlayerCombatant] = []
	for com in my_state_machine.combatants:
		if com is EnemyCombatant:
			enemies_to_process.append( com )
		elif com is PlayerCombatant:
			player_targets.append(com)
	
	enemy_decision_handler.handle_enemy_turn(enemies_to_process, player_targets)

func on_enemy_finished_turn(actions_to_send: Array[StoredAction]) -> void:
	my_state_machine.complete_player_turn( actions_to_send )
	my_state_machine.change_to_state("ResolveTurn")
