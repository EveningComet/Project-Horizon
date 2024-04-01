## Responsible for getting a healing value.
class_name DirectHealing extends SkillEffect

## Get the healing power.
func get_power(activator: Combatant) -> int:
	if use_special_stat == true:
		return get_special_power( activator )
	else:
		return get_physical_power( activator )
