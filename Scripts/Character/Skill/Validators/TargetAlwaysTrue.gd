## Component for skills that should always have a target in some form.
## For example, a basic attack.
class_name TargetAlwaysValid extends TargetValidator

func is_target_valid(target: Combatant) -> bool:
	return true
