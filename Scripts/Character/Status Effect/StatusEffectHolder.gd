## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
## { status_effect : status_effect_combat_data }
var statuses: Dictionary = {}


func initialize(combatant: Combatant) -> void:
	monitored_combatant = combatant
	
func add_status_effect(status_to_add: StatusEffect) -> void:
	statuses[status_to_add] = status_to_add.duration_in_turns
	status_to_add.trigger(monitored_combatant, StatusEffectTypes.Application.OnApply)
	print(monitored_combatant, ": added status ", status_to_add.localization_name, " for ", status_to_add.duration_in_turns, " turns")

func apply_status_effects() -> void:
	for status in statuses:
		if (statuses[status] <= 0):
			remove_status_effect(status)
		else:
			status.trigger(monitored_combatant, StatusEffectTypes.Application.OnTurnTick)
			statuses[status] -= 1
			print(monitored_combatant, ": ticked status ", status.localization_name, ", turns left: ", statuses[status])

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	status_to_remove.trigger(monitored_combatant, StatusEffectTypes.Application.OnExpire)
	statuses.erase(status_to_remove)
	print(monitored_combatant, ": removed status ", status_to_remove.localization_name)
