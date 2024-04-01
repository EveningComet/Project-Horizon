## Responsible for managing the decisions for the enemy.
class_name EnemyTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	print("EnemyTurn :: Entered.")

func physics_update(delta: float) -> void:
	my_state_machine.change_to_state("ResolveTurn")
