## Base class for defining what an ability/skill does.
class_name SkillEffect extends Resource

## For the skills that will need to scale the output by some value.
@export var power_scale: float = 1.0

## Does the skill require the special (will/mind/etc.) stat?
@export var use_special_stat: bool = false

## Get the power output. The value returned is typically used for damage and
## healing.
func get_power(activator: Combatant) -> int:
	if use_special_stat == true:
		return get_special_power( activator )
	else:
		return get_physical_power( activator )

## Get the power output with a scale overriding the stored value.
func get_power_with_alt_scale(activator: Combatant, new_scale: float) -> int:
	if use_special_stat == true:
		return get_special_power_with_alt_scale( activator, new_scale )
	else:
		return get_physical_power_with_alt_scale( activator, new_scale )

## Get the physical power for the passed character, using the stored power scale.
func get_physical_power(activator: Combatant) -> int:
	return floor( activator.get_physical_power() * power_scale )

func get_physical_power_with_alt_scale(activator: Combatant, new_scale: float) -> int:
	return floor( activator.get_physical_power() * new_scale )

## Get the special power for the passed character, using the stored power scale.
func get_special_power(activator: Combatant) -> int:
	return floor( activator.get_special_power() * power_scale )

func get_special_power_with_alt_scale(activator: Combatant, new_scale: float) -> int:
	return floor( activator.get_special_power() * new_scale )
