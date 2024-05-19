## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

## The name for this status effect.
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."
@export var display_texture: Texture2D
@export var is_contagious: bool
@export_range(0.0, 1.0, .05) var chance_of_spreading: float
@export var incubation_time: int
@export var on_apply: StatusEffectOnApplyData
@export var on_turn_tick: StatusEffectOnTurnTickData
@export var on_expire: StatusEffectOnExpireData
@export var is_negative: bool = false
@export var duration_in_turns: int = 1

func trigger_on_apply(combatant: Combatant):
	if on_apply != null:
		on_apply.trigger(combatant)

func trigger_on_turn_tick(combatant: Combatant, turns_elapsed: int):
	if on_turn_tick != null:
		on_turn_tick.trigger(combatant, turns_elapsed)

func trigger_on_expire(combatant: Combatant):
	if on_apply != null:
		on_apply.remove_modifiers(combatant)
	if on_expire != null:
		on_expire.trigger(combatant)
