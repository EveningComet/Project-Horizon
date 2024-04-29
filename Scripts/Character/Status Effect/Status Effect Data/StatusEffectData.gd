## Base class that describes what a status effect does.
class_name StatusEffectData extends Resource

@export var base_damage: int = 0
@export var damage_type: StatTypes.DamageTypes = StatTypes.DamageTypes.Base
	

func to_mediator(combatant: Combatant) -> ActionMediator:
	var action_mediator := ActionMediator.new()
	action_mediator.activator = combatant
	action_mediator.damage_data[damage_type] = base_damage
	return action_mediator
