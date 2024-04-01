## Stores data for a skill.
class_name SkillData extends Resource

## The name for the skill.
@export var localization_name: String = "New Skill"

## The description for this skill.
@export_multiline var localization_description: String = "New description."

## Does the skill have to be activated?
@export var is_passive: bool = false

## What is the targeting type for the skill, if needed?
@export var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy

## If the skill is not passive, how many times does it activate?
@export var num_activations: int = 1

## What is the highest level this skill can be?
@export var max_rank: int = 3

## The minimum rank of the previous skill needed to unlock this skill.
@export var minimum_rank_of_previous: int = 1

@export var base_power_scale: float = 1.0

## How much the skill gets upgraded for each rank.
@export var upgrade_scale: float = 5.0

## For skills that need a success chance, what is the base chance of succeeding?
@export_range(0.0, 1.0) var success_chance: float = 1.0

## The skills that get unlocked based on the rank of this skill.
@export var unlockable: Array[SkillData] = []

## If the skill is some form of attack, is it ranged?
@export var is_ranged: bool = false

## Defines what a skill does.
@export var effects: Array[SkillEffect] = []

## Get the needed data for the passed character.
func get_usable_data(activator: Combatant) -> ActionMediator:
	var action_mediator: ActionMediator = ActionMediator.new()
	
	# Loop through the effects, checking for ones that will increase the base damage
	action_mediator.damage_data["base_damage"] = 0
	
	# Check for anyone that will apply a status effect
	
	# Check if any of the effects will provide healing
	action_mediator.heal_amount = 0
	
	return action_mediator
