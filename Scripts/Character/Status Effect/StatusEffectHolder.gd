## Manages status effects for a character.
class_name StatusEffectHolder

## The stats of the character this holder is keeping track of.
var char_stats: Dictionary

## The current statuses and how many turns they have left.
var statuses: Dictionary = {}

func initialize(stats: Dictionary) -> void:
	char_stats = stats

func add_status_effect(status_to_add: StatusEffect) -> void:
	pass

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	pass
