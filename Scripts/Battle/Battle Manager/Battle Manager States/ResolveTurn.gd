## The battle state where the actions are executed.
class_name ResolveTurn extends BattleState

## The node responsible for executing the actions.
@export var action_executer: ActionExecutor

func enter(msgs: Dictionary = {}) -> void:
	print("ResolveTurn :: Entered.")
	action_executer.finished_processing_actions.connect( on_actions_finished_processing )
	# TODO: Sort the actions based on the activator's speed stat.
	check_start_of_turn_status_effects()
	execute_actions()

func exit() -> void:
	action_executer.finished_processing_actions.disconnect( on_actions_finished_processing )

func check_start_of_turn_status_effects() -> void:
	pass

## Tell the action executor to start doing work.
func execute_actions() -> void:
	action_executer.execute_actions( my_state_machine.current_turn_actions )

func on_actions_finished_processing() -> void:
	# TODO: Check if the next turn should be started or if the battle should end
	# TODO: Proper resolving of turn. For now, just go back to the player's turn.
	my_state_machine.change_to_state("PlayerTurn")
	
func prepare_battle_end() -> void:
	pass
