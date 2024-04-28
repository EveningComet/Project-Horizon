class_name StatusEffectExecutor extends Node


func trigger_on_apply(combatant: Combatant, status: StatusEffect):
	var effect := status.on_apply as StatusEffectOnApplyData
	if (effect != null):
		var action_mediator := effect.to_mediator(combatant)
		combatant.take_damage(action_mediator)

func trigger_on_turn_tick(combatant: Combatant, status: StatusEffect):
	var effect := status.on_turn_tick as StatusEffectOnTurnTickData
	if (effect != null):
		var action_mediator := effect.to_mediator(combatant)
		action_mediator.damage_data[effect.damage_type] += effect.damage_increase_per_turn
		combatant.take_damage(action_mediator)

func trigger_on_expire(combatant: Combatant, status: StatusEffect):
	var effect := status.on_expire as StatusEffectOnExpireData
	if (effect != null):
		var action_mediator := effect.to_mediator(combatant)
		combatant.take_damage(action_mediator)
	
