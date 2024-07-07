## A base class for a component that will decide if a target is valid for a
## skill or action.
class_name TargetValidator extends Resource

func is_target_valid(target: Combatant) -> bool:
	return false
