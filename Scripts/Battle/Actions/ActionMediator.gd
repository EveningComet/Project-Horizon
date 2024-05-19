## Responsible for mediating between the actions, skill data, and the like.
class_name ActionMediator

## The character that is doing the attack/heal/etc. Useful for attacks that
## heal the attacker.
var activator: Combatant

## Stores the different types of damage that can be applied.
var damage_data: Dictionary = {}

## The original, pre-calculation damage powers.
var damage_powers: Dictionary = {}

## The status effects that need to be sent. A key value pair of:
## {status effect : success chance}.
var status_effects_to_apply: Dictionary = {}

## How much healing to apply.
var heal_amount: int = 0

## Stores the power scalings for each damage type.
var power_scalings: Dictionary = {}

## If the target has status effects, how much should the damage be increased.
var status_damage_scalers: Dictionary = {}

## For attacks that heal the attacker.
var damage_heal_percentage: float = 0.0

## How many times an individual character can attack at once, heal, etc.
var num_activations: int = 1

## Go through the container for damage data and return that as potential damage.
func get_total_possible_damage() -> int:
	var potential_damage: int = 0
	for damage_type in StatTypes.DamageTypes:
		if damage_data.has(damage_type) == true:
			potential_damage += damage_data[damage_type]
	return potential_damage

## If the target has at least one debuff applied, this will cause the damage
## to be scaled.
func get_debuff_scaled_damage(damage_type: StatTypes.DamageTypes) -> int:
	var original_damage:     int   = damage_powers[damage_type]
	var power_scale:         float = power_scalings[damage_type]
	var status_damage_scale: float = status_damage_scalers[damage_type]
	var new_damage: int = floor(
		original_damage * (power_scale + status_damage_scale)
	)
	return new_damage

func deals_more_damage_when_debuffs_present() -> bool:
	for dt in status_damage_scalers.keys():
		if status_damage_scalers[dt] > 0.0:
			return true
	return false

## Get the lifesteal which is based on the stored percentage, the damage type,
## and the target's health.
func get_lifesteal_amount(damage_type: StatTypes.DamageTypes, target: Combatant) -> int:
	var lifesteal_amount: int = 0
	var damage: int = damage_data[damage_type]
	lifesteal_amount = floor( damage * damage_heal_percentage )
	
	# Make sure the lifesteal is not outside of the range of the target's health
	# and return it
	lifesteal_amount = clamp(lifesteal_amount, 1, target.get_current_hp())
	return lifesteal_amount
