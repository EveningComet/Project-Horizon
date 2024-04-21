## Responsible for mediating between the actions, skill data, and the like.
class_name ActionMediator

## Stores the different types of damage that can be applied.
var damage_data: Dictionary = {}

## The status effects that need to be sent. A key value pair of:
## {status effect : success chance}.
var status_effects_to_apply: Dictionary = {}

## How much healing to apply.
var heal_amount: int = 0

## Go through the container for damage data and return that as potential damage.
func get_total_possible_damage() -> int:
	var potential_damage: int = 0
	for damage_type in StatTypes.DamageTypes:
		if damage_data.has(damage_type) == true:
			potential_damage += damage_data[damage_type]
	return potential_damage
