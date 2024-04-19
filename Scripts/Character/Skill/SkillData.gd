## Stores data for a skill.
class_name SkillData extends Resource

## The name for the skill.
@export var localization_name: String = "New Skill"

## The description for this skill.
@export_multiline var localization_description: String = "New description."

## How many special points it costs to use this skill.
@export var cost: int = 5

## Does the skill have to be activated?
@export var is_passive: bool = false

## What is the action type for the skill, if needed?
@export var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy

## What is the "point" of this skill? This is used to help the AI make decisions.
@export var skill_type: SkillTypes.SkillTypes

## If the skill is not passive, how many times does it activate?
@export var num_activations: int = 1

## What is the highest level this skill can be?
@export var max_rank: int = 3

## The minimum rank of the previous skill needed to unlock this skill.
@export var minimum_rank_of_previous: int = 1

## If belonging to a class, at what class level should this skill be unlocked?
@export var unlocks_at_class_level: int = 1

## For skills that need a success chance, what is the base chance of succeeding?
@export_range(0.0, 1.0) var success_chance: float = 1.0

## If the skill is unlocked by default
@export var is_unlocked_by_default: bool = false

## The skills that get unlocked based on the rank of this skill.
@export var unlockable: Array[SkillData] = []

## If the skill is some form of attack, is it ranged?
@export var is_ranged: bool = false

## Defines what a skill does.
@export var effects: Array[SkillEffect] = []

## Texture for button in skills menu
@export var display_texture: Texture2D

## Get the needed data for the passed character.
func get_usable_data(activator: Combatant) -> ActionMediator:
	var action_mediator: ActionMediator = ActionMediator.new()
	
	# Loop through the effects, checking for ones that will increase the base damage
	action_mediator.damage_data["base_damage"] = 0
	action_mediator.status_effects_to_apply = {}
	action_mediator.heal_amount = 0
	for effect: SkillEffect in effects:
		# Check for damage
		if effect is DirectDamage:
			var damage_effect = effect as DirectDamage
			action_mediator.damage_data["base_damage"] += damage_effect.get_power( activator )
	
		# Check for status effects
		elif effect is ApplyStatusEffect:
			var ase = effect as ApplyStatusEffect
			action_mediator.status_effects_to_apply[ase.status_effect_to_apply] = ase.chance_to_apply
	
		# Check if any of the effects will provide healing
		elif effect is DirectHealing:
			var healing_effect = effect as DirectHealing
			action_mediator.heal_amount += healing_effect.get_power( activator )
		
		## See what permanent stat boosters will be applied
		elif effect is PermanentStatBooster:
			# TODO: Safety check to make sure the exact boost is not being applied
			# multiple times?
			pass
	
	return action_mediator
