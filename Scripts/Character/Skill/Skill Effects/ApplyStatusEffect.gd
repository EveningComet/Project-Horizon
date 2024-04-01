## A skill effect that applies a status effect.
class_name ApplyStatusEffect extends SkillEffect

## The status effect that this will apply.
@export var status_effect_to_apply: StatusEffect

## The chance of this being applied.
@export_range(0.0, 1.0, .05) var chance_to_apply: float = 0.1

## Return the status effect as a key value pair of the status effect and the
## chance for success.
func get_status_effect() -> Dictionary:
	return {status_effect_to_apply = chance_to_apply}
