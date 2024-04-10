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
	EventBus.side_finished_turn.emit( actions_to_send )

func on_enemy_finished_turn(actions_to_send: Array[StoredAction]) -> void:
	my_state_machine.complete_player_turn( actions_to_send )
	my_state_machine.change_to_state("ResolveTurn")
