## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
var statuses: Dictionary = {}

## The queued statuses and how many turns before their activation
var queued_statuses: Dictionary = {}

func _init(combatant: Combatant):
	monitored_combatant = combatant

func get_contagious_status_effects() -> Array:
	return statuses.keys().filter(func(status): return status.is_contagious)

func queue_status_effect(status_to_queue: StatusEffect) -> void:
	if not queued_statuses.has(status_to_queue) and not statuses.has(status_to_queue):
		queued_statuses[status_to_queue] = status_to_queue.incubation_time
		print(monitored_combatant, ": queued status effect ", status_to_queue.localization_name, ", incubation time: ", queued_statuses[status_to_queue], " turns")

func add_status_effect(status_to_add: StatusEffect) -> void:
	if (not statuses.has(status_to_add)):
		statuses[status_to_add] = status_to_add.duration_in_turns
		status_to_add.trigger_on_apply(monitored_combatant)
		monitored_combatant.status_effect_added.emit(monitored_combatant, status_to_add)
		print(monitored_combatant, ": added status effect ", status_to_add.localization_name, " for ", status_to_add.duration_in_turns, " turns")


func apply_status_effects() -> void:
	for status in statuses:
		if (statuses[status] <= 0):
			remove_status_effect(status)
		else:
			var turns_elapsed: int = status.duration_in_turns - statuses[status] + 1
			status.trigger_on_turn_tick(monitored_combatant, turns_elapsed)
			statuses[status] -= 1
			print(monitored_combatant, ": ticked status effect ", status.localization_name, ", turns left: ", statuses[status])
	tick_queued_effects()


func tick_queued_effects() -> void:
	for status in queued_statuses:
		queued_statuses[status] -= 1
		if queued_statuses[status] == 0:
			add_status_effect(status)
			queued_statuses.erase(status)

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	status_to_remove.trigger_on_expire(monitored_combatant)
	statuses.erase(status_to_remove)
	monitored_combatant.status_effect_removed.emit(monitored_combatant, status_to_remove)
	print(monitored_combatant, ": removed status effect ", status_to_remove.localization_name)

## Are there status effects considered negative?
func has_negative_statuses_present() -> bool:
	for status: StatusEffect in statuses.keys():
		if status.is_negative == true:
			return true
	return false
