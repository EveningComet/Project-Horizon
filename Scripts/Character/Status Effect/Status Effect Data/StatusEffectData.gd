## Base class that describes what a status effect does.
class_name StatusEffectData extends Resource

@export var base_damage: int = 0

## Used so that it plays nice with the skill system.
@export var power_scale: float = 1.0

## Used so that it plays nice with the skill system. Could be used to deal
## more damage when a status is present.
@export var status_damage_scaler: float = 0.0

@export var damage_type: StatTypes.DamageTypes = StatTypes.DamageTypes.Base
@export var stat_modifiers: Array[StatModifier] = []

func to_mediator(combatant: Combatant) -> ActionMediator:
	var action_mediator := ActionMediator.new()
	action_mediator.activator = combatant
	action_mediator.damage_data[damage_type]           = base_damage
	action_mediator.power_scalings[damage_type]        = power_scale
	action_mediator.status_damage_scalers[damage_type] = status_damage_scaler
	return action_mediator

func apply_modifiers(combatant: Combatant):
	for modifier in stat_modifiers:
		combatant.add_modifier(modifier.stat_changing, modifier)
		print(combatant, ": status effect added modifier for ", StatTypes.new().stat_types_to_string[modifier.stat_changing], " ", modifier.value)

func remove_modifiers(combatant: Combatant):
	for modifier in stat_modifiers:
		combatant.remove_modifier(modifier.stat_changing, modifier)
		print(combatant, ": status effect removed modifier for ", StatTypes.new().stat_types_to_string[modifier.stat_changing], " ", modifier.value)
