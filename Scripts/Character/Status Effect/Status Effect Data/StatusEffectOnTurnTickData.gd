## Contains information to apply status effects
class_name StatusEffectOnTurnTickData extends StatusEffectData


@export_range(0.0, 1.0, .05) var increase_ratio_per_turn: float = 0

func damage_increase_per_turn() -> int:
	return floor(increase_ratio_per_turn * base_damage)
