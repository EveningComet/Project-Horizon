## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

## The name for this status effect.
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."

@export var on_apply: StatusEffectOnApplyData
@export var on_turn_tick: StatusEffectOnTurnTickData
@export var on_expire: StatusEffectOnExpireData


func apply(character_to_add_to: Combatant) -> void:
	pass

func remove(character_to_remove_from: Combatant) -> void:
	pass
