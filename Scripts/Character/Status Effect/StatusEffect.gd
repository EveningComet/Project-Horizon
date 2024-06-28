## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

## The name for this status effect.
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."
@export var display_texture: Texture2D
@export var is_contagious: bool
@export_range(0.0, 1.0, .05) var chance_of_spreading: float
@export var incubation_time: int
@export var on_apply: Array[StatusEffectOnApplyData]
@export var on_turn_tick: Array[StatusEffectOnTurnTickData]
@export var on_expire: Array[StatusEffectOnExpireData]
@export var is_negative: bool = false
@export var duration_in_turns: int = 1

func trigger_on_apply(combatant: Combatant):
	for effect in on_apply:
		effect.trigger(combatant)

func trigger_on_turn_tick(combatant: Combatant, turns_elapsed: int):
	for effect in on_turn_tick:
		effect.trigger(combatant, turns_elapsed)

func trigger_on_expire(combatant: Combatant):
	for effect in on_apply:
		effect.remove_modifiers(combatant)
	for effect in on_expire:
		effect.trigger(combatant)
