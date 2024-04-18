## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

enum ApplicationType {
	EveryTurn, ## For statuses that do a thing every turn.
	OnSet,     ## When the status effect is first applied.
	OnRemoval  ## Does the status do its thing when it wears off?
}

## The name for this status effect.
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."

@export var application_type: ApplicationType

## Defines what the status effect does.
@export var effects: Array[StatusEffectData] = []

func apply(character_to_add_to: Combatant) -> void:
	pass

func remove(character_to_remove_from: Combatant) -> void:
	pass
