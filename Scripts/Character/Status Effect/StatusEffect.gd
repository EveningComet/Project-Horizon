## A thing that exists on a character and does something to them.
class_name StatusEffect extends Resource

## The name for this status effect.
@export var localization_name:                  String = "New Status Effect"
@export_multiline var localization_description: String = "Status effect description."

@export var on_apply: StatusEffectOnApplyData
@export var on_turn_tick: StatusEffectOnTurnTickData
@export var on_expire: StatusEffectOnExpireData
@export var duration_in_turns: int = 0

func trigger_on_apply(combatant: Combatant):
	if (on_apply != null):
		var action_mediator := on_apply.to_mediator(combatant)
		combatant.take_damage(action_mediator)

func trigger_on_turn_tick(combatant: Combatant, turns_elapsed: int):
	if (on_turn_tick != null):
		var action_mediator := on_turn_tick.to_mediator(combatant)
		action_mediator.damage_data[on_turn_tick.damage_type] += turns_elapsed * on_turn_tick.damage_increase_per_turn() 
		combatant.take_damage(action_mediator)

func trigger_on_expire(combatant: Combatant):
	if (on_expire != null):
		var action_mediator := on_expire.to_mediator(combatant)
		combatant.take_damage(action_mediator)
