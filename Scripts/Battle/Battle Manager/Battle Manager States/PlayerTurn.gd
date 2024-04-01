## When it is the player's turn in the battle.
class_name PlayerTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.begin_player_turn()
	
	print("PlayerTurn :: Current turn is: ", my_state_machine.current_turn)
	print("PlayerTurn :: Entered.")

func exit() -> void:
	pass
