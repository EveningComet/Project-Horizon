## Responsible for executing the actions during the resolve phase.
class_name ActionExecutor extends Node

## Depending on how the action execution is halted, this will tell any listeners
## the result.
signal finished_processing_actions(results: Dictionary)

## Used for checking for battle ends and if characters are dead.
@export var death_handler: BattleDeathHandler

## The actions that will be executed during the resolve phase.
var actions_to_execute: Array[StoredAction] = []

## Random number generator used to calculate chances.
var prng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	prng.randomize()

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
	# Safety check for making sure the activator still exists
	var activator: Combatant = action.activator
	if activator == null or activator.stats[StatTypes.stat_types.CurrentHP] <= 0:
		next_action()
		return
		
	var action_mediator: ActionMediator = ActionMediator.new()
	
	# Get all the data we need before hand
	var has_skill: bool = action.skill_instance != null
	if has_skill == true:
		# TODO: Proper getting of the power based on the upgrade.
		action_mediator = action.skill_instance.monitored_skill.get_usable_data( activator )
		# TODO: Get the skill chance to hit.
		# TODO: Proper getting of the subtraction based on the instance upgrade level.
		activator.sub_sp( action.skill_instance.monitored_skill.cost )
	
	# Get some normal damage
	else:
		# TODO: Account for the different damage types depending on other factors.
		var power = activator.get_physical_power()
		action_mediator.damage_data[StatTypes.DamageTypes.Base] = power
	
	# Check what to do based on the stored action object
	match action.action_type:
		ActionTypes.ActionTypes.AllEnemies, ActionTypes.ActionTypes.SingleEnemy:
			
			# TODO: If enemy target is dead, and their are still enemies, target another enemy.
			for target: Combatant in action.get_targets():
				if target != null:
					var generated_number: int = prng.randi() % 101
					
					if OS.is_debug_build() == true:
						print("ActionExecutor :: PRNG generated %s for chance to hit." % [str(generated_number)])
					
					# Chance to hit
					if generated_number <= Formulas.get_chance_to_hit(activator, target):
						# TODO: Crit chance
						# Apply damage
						target.take_damage( action_mediator.damage_data )
					
					# TODO: Apply status effects, if any
		
		ActionTypes.ActionTypes.AllAllies, ActionTypes.ActionTypes.SingleAlly:
			for target: Combatant in action.get_targets():
				if target != null:
					# TODO: Chance for success?
					target.heal( action_mediator.heal_amount )
					
					# TODO: Apply status effects, if any
					
					if OS.is_debug_build() == true:
						print("ActionExecutor :: %s got healed %s" % [target, action_mediator.heal_amount])
		
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
