## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
var statuses: Dictionary = {}


func initialize(combatant: Combatant) -> void:
	monitored_combatant = combatant
	
func add_status_effect(status_to_add: StatusEffect) -> void:
	statuses[status_to_add] = status_to_add.duration_in_turns
	status_to_add.trigger_on_apply(monitored_combatant)
	print(monitored_combatant, ": added status ", status_to_add.localization_name, " for ", status_to_add.duration_in_turns, " turns")

func apply_status_effects() -> void:
	for status in statuses:
		if (statuses[status] <= 0):
			remove_status_effect(status)
		else:
			var turns_elapsed: int = status.duration_in_turns - statuses[status] + 1
			status.trigger_on_turn_tick(monitored_combatant, turns_elapsed)
			statuses[status] -= 1
			print(monitored_combatant, ": ticked status ", status.localization_name, ", turns left: ", statuses[status])

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	status_to_remove.trigger_on_expire(monitored_combatant)
	statuses.erase(status_to_remove)
	print(monitored_combatant, ": removed status ", status_to_remove.localization_name)
