## Contains information to apply status effects
class_name StatusEffectOnExpireData extends StatusEffectData


func trigger(combatant: Combatant):
	var action_mediator := to_mediator(combatant)
	combatant.take_damage(action_mediator)
