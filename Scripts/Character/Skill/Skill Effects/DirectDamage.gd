## Deals damage directly to a target.
class_name DirectDamage extends SkillEffect

@export var damage_type: StatTypes.DamageTypes

func get_power(activator: Combatant) -> int:
	# TODO: Refactor for applying typed and elemental damage.
	if use_special_stat == true:
		return get_special_power( activator )
	else:
		return get_physical_power( activator )
