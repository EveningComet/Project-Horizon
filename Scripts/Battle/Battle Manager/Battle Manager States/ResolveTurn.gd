## The battle state where the actions are executed.
class_name ResolveTurn extends BattleState

## The node responsible for executing the actions.
@export var action_executer: ActionExecutor

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("ResolveTurn :: Entered.")
	
	action_executer.finished_processing_actions.connect( on_action_execution_finished )
	my_state_machine.current_turn_actions.sort_custom( sort_actions_based_on_activator_speed )
	check_start_of_turn_status_effects()
	execute_actions()

func exit() -> void:
	action_executer.finished_processing_actions.disconnect( on_action_execution_finished )

func check_start_of_turn_status_effects() -> void:
	pass

## Tell the action executor to start doing work.
func execute_actions() -> void:
	action_executer.execute_actions( my_state_machine.current_turn_actions )

func on_action_execution_finished(results: Dictionary = {}) -> void:
	match results:
		# A side has won the battle, time to close things down
		{"player_victory": var did_player_win}:
			my_state_machine.change_to_state("EndBattle", results)
			return
	
	my_state_machine.change_to_state("PlayerTurn")

func sort_actions_based_on_activator_speed(a: StoredAction, b: StoredAction) -> bool:
	return a.activator.stats[StatTypes.stat_types.Speed].get_calculated_value() < \
	b.activator.stats[StatTypes.stat_types.Speed].get_calculated_value()

