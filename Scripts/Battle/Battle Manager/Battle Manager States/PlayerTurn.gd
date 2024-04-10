## When it is the player's turn in the battle.
class_name PlayerTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.current_turn_actions.clear()
	my_state_machine.current_turn += 1
	EventBus.side_finished_turn.connect( on_player_turn_ended )
	EventBus.begin_player_turn.emit()
	
	if OS.is_debug_build() == true:
		print("PlayerTurn :: Current turn is: ", my_state_machine.current_turn)
		print("PlayerTurn :: Entered.")

func exit() -> void:
	EventBus.side_finished_turn.disconnect( on_player_turn_ended )

func on_player_turn_ended(actions: Array[StoredAction]) -> void:
	my_state_machine.complete_player_turn( actions )
	my_state_machine.change_to_state("EnemyTurn")
