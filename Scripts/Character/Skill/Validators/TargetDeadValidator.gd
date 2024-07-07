## Checks if a target has hp <= 0. Mainly used for player characters, since
## enemies should just go away when they die.
class_name TargetDeadValidator extends TargetValidator

func is_target_valid(target: Combatant) -> bool:
	return target.get_current_hp() <= 0
