## Stores data for a skill.
class_name SkillData extends Resource

## The name for the skill.
@export var localization_name: String = "New Skill"

## The description for this skill.
@export_multiline var localization_description: String = "New description."

## Does the skill have to be activated?
@export var is_passive: bool = false

## What is the action type for the skill, if needed?
@export var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy

## What is the "point" of this skill? This is used to help the AI make decisions.
@export var skill_type: SkillTypes.SkillTypes

## If the skill is not passive, how many times does it activate?
@export var num_activations: int = 1

## The minimum rank of the previous skill needed to unlock this skill.
@export var minimum_rank_of_previous: int = 0

## If belonging to a class, at what class level should this skill be unlocked?
@export var unlocks_at_class_level: int = 1

## For skills that need a success chance, what is the base chance of succeeding?
@export_range(0.0, 1.0) var success_chance: float = 1.0

## If the skill is unlocked by default
@export var is_unlocked_by_default: bool = false

## The tier tiers for this skill. Think of this as above rank 1.
@export var tiers: Array[SkillTier] = []

## The skills that get unlocked based on the rank of this skill.
@export var branches: Array[SkillData] = []

## If the skill is some form of attack, is it ranged?
@export var is_ranged: bool = false

## Defines what a skill does.
@export var effects: Array[SkillEffect] = []

## Texture for button in skills menu
@export var display_texture: Texture2D

## The max rank is determined by the amount of tiers.
var max_rank: int = 1:
	get:
		return tiers.size()

## Get the cost based on the upgrade level.
func get_cost(upgrade_level: int = 0) -> int:
	if upgrade_level > 0 and upgrade_level - 1 < tiers.size():
		return get_tier(upgrade_level).cost
	return tiers[0].cost

## Get the needed data for the passed character.
## The upgrade level determines things such as power scaling.
func get_usable_data(activator: Combatant, upgrade_level: int = 0) -> ActionMediator:
	var action_mediator: ActionMediator = ActionMediator.new()
	action_mediator.activator = activator
	action_mediator.num_activations = num_activations
	
	var tier: SkillTier = get_tier(upgrade_level)
	
	# Loop through the effects
	action_mediator.damage_data             = {}
	action_mediator.status_effects_to_apply = {}
	action_mediator.heal_amount             = 0
	for effect: SkillEffect in effects:
		
		# Check for damage
		if effect is DirectDamage:
			var damage_effect = effect as DirectDamage
			var damage_type   = damage_effect.damage_type
			
			if action_mediator.damage_data.has(damage_type) == true:
				action_mediator.damage_data[damage_type] += get_power(
					activator, upgrade_level, damage_effect
				)
				action_mediator.power_scalings[damage_type] += get_power_scale(
					upgrade_level
				)
				action_mediator.status_damage_scalers[damage_type] += get_bonus_power_on_debuffs_present(
					activator, upgrade_level, damage_effect
				)
				action_mediator.damage_powers[damage_type] += get_uncalculated_power(activator, damage_effect)
			else:
				action_mediator.damage_data[damage_type] = get_power(
					activator, upgrade_level, damage_effect
				)
				action_mediator.power_scalings[damage_type] = get_power_scale(
					upgrade_level
				)
				action_mediator.status_damage_scalers[damage_type] = get_bonus_power_on_debuffs_present(
					activator, upgrade_level, damage_effect
				)
				action_mediator.damage_powers[damage_type] = get_uncalculated_power(activator, damage_effect)
	
		# Check for status effects
		elif effect is ApplyStatusEffect:
			var ase = effect as ApplyStatusEffect
			action_mediator.status_effects_to_apply[ase.status_effect_to_apply] = ase.chance_to_apply
	
		# Check if any of the effects will provide healing
		elif effect is DirectHealing:
			var healing_effect = effect as DirectHealing
			action_mediator.heal_amount += get_power(
				activator,
				upgrade_level,
				healing_effect
			)
	
	return action_mediator

func get_power(activator: Combatant, upgrade_level: int, e: SkillEffect) -> int:
	var new_scale: float = get_tier(upgrade_level).power_scale
	return e.get_power_with_alt_scale(activator, new_scale)

func get_uncalculated_power(activator: Combatant, e: SkillEffect) -> int:
	return e.get_uncalculated_power(activator)

func get_power_scale(upgrade_level: int) -> float:
	return get_tier(upgrade_level).power_scale

func get_bonus_power_on_debuffs_present(
		activator: Combatant, upgrade_level: int, de: DirectDamage
	) -> float:
		return get_tier(upgrade_level).bonus_damage_scale_on_debuffs_present

## Return a tier.
func get_tier(upgrade_level: int) -> SkillTier:
	return tiers[upgrade_level - 1]
