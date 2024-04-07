## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

## The name for this status effect.
@export var localization_name: String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."

## Does the status do its thing every turn?
@export var applies_every_turn: bool = false

## Does the status only do its thing when it gets set on a character?
@export var applies_on_set: bool = false

## Does the status do its thing when it wears off?
@export var applies_on_removal: bool = false

## Defines what the status effect does.
@export var effects: Array[StatusEffectData] = []

func apply(character_to_add_to: Combatant) -> void:
	pass

func remove(character_to_remove_from: Combatant) -> void:
	pass
