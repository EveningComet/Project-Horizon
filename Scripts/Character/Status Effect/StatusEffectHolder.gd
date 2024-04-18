## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
var statuses: Dictionary = {}

func initialize(combatant: Combatant) -> void:
	monitored_combatant = combatant

func add_status_effect(status_to_add: StatusEffect) -> void:
	pass

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	pass
