## Deals damage directly to a target.
class_name DirectDamage extends SkillEffect

## Dictates what type of damage should be returned.
@export var damage_type: StatTypes.DamageTypes = StatTypes.DamageTypes.Base

func get_power(activator: Combatant) -> int:
	if use_special_stat == true:
		return get_special_power( activator )
	else:
		return get_physical_power( activator )
