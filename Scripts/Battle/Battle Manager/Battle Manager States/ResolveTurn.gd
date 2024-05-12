## The battle state where the actions are executed.
class_name ResolveTurn extends BattleState

## The node responsible for executing the actions.
@export var action_executer: ActionExecutor

## Random number generator used to calculate chances.
var prng: RandomNumberGenerator = RandomNumberGenerator.new()


func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("ResolveTurn :: Entered.")
	
	prng.randomize()
	action_executer.finished_processing_actions.connect( on_action_execution_finished )
	my_state_machine.current_turn_actions.sort_custom( sort_actions_based_on_activator_speed )
	check_start_of_turn_status_effects()
	execute_actions()

func exit() -> void:
	action_executer.finished_processing_actions.disconnect( on_action_execution_finished )

func check_start_of_turn_status_effects() -> void:
	var contagious_to_group: Dictionary = {}
	for combatant_node in my_state_machine.spawned_combatants_node.get_children():
		var combatant := combatant_node as Combatant
		combatant.status_effect_holder.apply_status_effects()
		for effect in combatant.status_effect_holder.get_contagious_status_effects():
			contagious_to_group[effect] = my_state_machine.PLAYER_GROUP_NAME\
			if combatant.is_in_group(my_state_machine.PLAYER_GROUP_NAME)\
			else my_state_machine.ENEMY_GROUP_NAME
	apply_contagious_status_effects(contagious_to_group)

func apply_contagious_status_effects(contagious_to_group: Dictionary) -> void:
	for effect in contagious_to_group:
		var applicable_combatants := get_tree().get_nodes_in_group(contagious_to_group[effect])
		var random_combatant := applicable_combatants[randi_range(0, len(applicable_combatants) - 1)]
		if (prng.randf_range(0.0, 1.0) <= effect.chance_of_spreading):
			random_combatant.status_effect_holder.queue_status_effect(effect)

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

