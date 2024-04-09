## Responsible for executing the actions during the resolve phase.
class_name ActionExecutor extends Node

## Depending on how the action execution is halted, this will tell any listeners
## the result.
signal finished_processing_actions(results: Dictionary)

## Used for checking for battle ends and if characters are dead.
@export var death_handler: BattleDeathHandler

## The actions that will be executed during the resolve phase.
var actions_to_execute: Array[StoredAction] = []

## Loop through the passed actions that need to be performed.
func execute_actions(actions: Array[StoredAction]) -> void:
	actions_to_execute.append_array( actions )
	
	# Execute the actions
	if OS.is_debug_build() == true:
		printerr("ResolveTurn :: Actions to execute: %s " % [actions])
	
	next_action()

## Continously executes actions until it is no longer able to.
func next_action() -> void:
	var results: Dictionary = {}
	
	# Check if a side has won
	if death_handler.results.has("player_victory"):
		results = death_handler.results
		finished_processing_actions.emit( death_handler.results )
		return
	
	# There are no more actions that need executing
	if actions_to_execute.size() == 0:
		finished_processing_actions.emit(results)
		return
	
	# Get the next action to execute
	var current_action: StoredAction = actions_to_execute.pop_front()
	execute_action( current_action )

func execute_action(action: StoredAction) -> void:
	# TODO: Safety checks to make sure the activator and targets are not dead.
	var activator: Combatant = action.activator
	var action_mediator: ActionMediator = ActionMediator.new()
	
	# Check what to do based on the stored action object
	match action.action_type:
		ActionTypes.ActionTypes.AllEnemies, ActionTypes.ActionTypes.SingleEnemy:
			## TODO: Get the right kind of power. For now, just use the physical power.
			var strength: int = activator.get_physical_power()
			action_mediator.damage_data["base_damage"] = 0
			action_mediator.damage_data["base_damage"] += strength
			
			# TODO: If enemy target is dead, and their are still enemies, target another enemy.
			# TODO: Chance to hit + critical chance.
			for target: Combatant in action.get_targets():
				target.take_damage( action_mediator.damage_data["base_damage"] )
				
		
		ActionTypes.ActionTypes.AllAllies, ActionTypes.ActionTypes.SingleAlly:
			var healing_power: int = 0
			healing_power = action.skill_data.get_usable_data( activator ).heal_amount
			for target: Combatant in action.get_targets():
				target.heal( healing_power )
				if OS.is_debug_build() == true:
					print("ActionExecutor :: %s got healed %s" % [target, healing_power])
		
		ActionTypes.ActionTypes.Flee:
			# TODO: Proper running away from a battle.
			get_tree().quit()
	
	# Execute the mediator
	await execute_mediator( action_mediator )
	
	# The action has been finished, move onto the next one, if able
	next_action()

## Execute the passed mediator.
func execute_mediator(action_mediator: ActionMediator) -> void:
	# TODO: The mediator is where damage, healing, etc. should go. Execute action should get the needed data.
	# TODO: Figure out delays for animations and such.
	await get_tree().create_timer(0.5).timeout
