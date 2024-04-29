## Responsible for mediating between the actions, skill data, and the like.
class_name ActionMediator

## The character that is doing the attack/heal/etc. Useful for attacks that
## heal the attacker.
var activator: Combatant

## Stores the different types of damage that can be applied.
var damage_data: Dictionary = {}

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
	var original_damage:     int = damage_data[damage_type]
	var power_scale:         float = power_scalings[damage_type]
	var status_damage_scale: float = status_damage_scalers[damage_type]
	var new_damage: int = floor(
		original_damage * (power_scale + status_damage_scale)
	)
	return new_damage
