## Deals damage directly to a target.
class_name DirectDamage extends SkillEffect

## Dictates what type of damage should be returned.
@export var damage_type: StatTypes.DamageTypes = StatTypes.DamageTypes.Base

## If the target has at least on debuff applied to them, how much extra damage
## should be applied?
@export var bonus_damage_scale_on_debuffs_present: float = 0.0

## Scales the percentage of damage that should be healed for the attacker.
@export_range(0.0, 1.0) var attacker_heal_percentage: float = 0.0

func get_power(activator: Combatant) -> int:
	if use_special_stat == true:
		return get_special_power( activator )
	else:
		return get_physical_power( activator )
