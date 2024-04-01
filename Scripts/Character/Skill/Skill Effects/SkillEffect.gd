## Base class for defining what an ability does.
class_name SkillEffect extends Resource

## For the skills that will need to scale the output by some value.
@export var power_scale: float = 1.0

## Does the skill require the special (will/mind/etc.) stat?
@export var use_special_stat: bool = false

## Get the power output of this ability.
func get_power(activator: Combatant) -> int:
	return 0

## Get the physical power for the passed character.
func get_physical_power(activator: Combatant) -> int:
	return floor( activator.get_physical_power() * power_scale )

## Get the special power for the passed character.
func get_special_power(activator: Combatant) -> int:
	return floor( activator.get_special_power() * power_scale )
