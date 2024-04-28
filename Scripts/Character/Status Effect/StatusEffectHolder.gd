## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
## { status_effect : status_effect_combat_data }
var statuses: Dictionary = {}

var executor:= StatusEffectExecutor.new()

func initialize(combatant: Combatant) -> void:
	monitored_combatant = combatant
	
func add_status_effect(status_to_add: StatusEffect) -> void:
	executor.trigger_on_apply(monitored_combatant, status_to_add)
	statuses[status_to_add] = status_to_add.duration_in_turns
	print(monitored_combatant, ": added status ", status_to_add.localization_name, " for ", status_to_add.duration_in_turns, " turns")

func apply_status_effects() -> void:
	for status in statuses:
		if (statuses[status] <= 0):
			remove_status_effect(status)
		else:
			executor.trigger_on_turn_tick(monitored_combatant, status)
			statuses[status] -= 1
			print(monitored_combatant, ": ticked status ", status.localization_name, ", turns left: ", statuses[status])

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	executor.trigger_on_expire(monitored_combatant, status_to_remove)
	statuses.erase(status_to_remove)
	print(monitored_combatant, ": removed status ", status_to_remove.localization_name)
