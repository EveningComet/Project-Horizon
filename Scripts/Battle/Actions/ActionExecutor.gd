## Responsible for executing the actions during the resolve phase.
class_name ActionExecutor extends Node

## Fired when the job is done.
signal finished_processing_actions

## The actions that will be executed during the resolve phase.
var actions_to_execute: Array[StoredAction] = []

func execute_actions(actions: Array[StoredAction]) -> void:
	actions_to_execute.append_array( actions )
	
	# Execute the actions
	printerr("ResolveTurn :: Actions to execute: %s " % [actions])
	next_action()

## Continously executes actions until it is no longer able to.
func next_action() -> void:
	
	# Before checking for the next action, see if the battle should end
	# There are no more actions that need executing
	if actions_to_execute.size() == 0:
		finished_processing_actions.emit()
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
		ActionTypes.ActionTypes.SingleEnemy:
			## TODO: Get the right kind of power. For now, just use the physical power.
			var strength: int = activator.get_physical_power()
			action_mediator.damage_data["base_damage"] = 0
			action_mediator.damage_data["base_damage"] += strength
			
			for target: Combatant in action.get_targets():
				target.take_damage( action_mediator.damage_data["base_damage"] )
				
				# TODO: If enemy target is dead, and their are still enemies, target another enemy.
				# TODO: Chance to hit + critical chance.
				print("ResolveTurn :: %s now has %s hp." % [target.name, target.stats[StatTypes.stat_types.CurrentHP]])
		
		ActionTypes.ActionTypes.HealSingleAlly:
			var healing_power: int = 0
			healing_power = action.skill_data.get_usable_data( activator ).heal_amount
			for target: Combatant in action.get_targets():
				target.heal( healing_power )
	
	# Execute the mediator
	await execute_mediator( action_mediator )
	
	# The action has been finished, move onto the next one, if able
	next_action()

## Execute the passed mediator.
func execute_mediator(action_mediator: ActionMediator) -> void:
	# TODO: The mediator is where damage, healing, etc. should go. Execute action should get the needed data.
	# TODO: Figure out delays for animations and such.
	await get_tree().create_timer(0.5).timeout
