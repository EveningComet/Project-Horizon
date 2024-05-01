## Contains information to apply status effects
class_name StatusEffectOnTurnTickData extends StatusEffectData


@export_range(0.0, 1.0, .05) var increase_ratio_per_turn: float = 0

func damage_increase_per_turn() -> int:
	return floor(increase_ratio_per_turn * base_damage)

func trigger(combatant: Combatant, turns_elapsed: int):
	var action_mediator := to_mediator(combatant)
	action_mediator.damage_data[damage_type] += turns_elapsed * damage_increase_per_turn() 
	combatant.take_damage(action_mediator)
