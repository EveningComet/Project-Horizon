## Base class that describes what a status effect does.
class_name StatusEffectData extends Resource

@export var base_damage: int = 0
@export var damage_type: StatTypes.DamageTypes = StatTypes.DamageTypes.Base
@export var stat_modifiers: Array[StatModifier] = []
	

func to_mediator(combatant: Combatant) -> ActionMediator:
	var action_mediator := ActionMediator.new()
	action_mediator.activator = combatant
	action_mediator.damage_data[damage_type] = base_damage
	return action_mediator

func apply_modifiers(combatant: Combatant):
	for modifier in stat_modifiers:
		combatant.add_modifier(modifier.stat_changing, modifier)
		print(combatant, ": status effect added modifier for ", StatTypes.new().stat_types_to_string[modifier.stat_changing], " ", modifier.value)

func remove_modifiers(combatant: Combatant):
	for modifier in stat_modifiers:
		combatant.remove_modifier(modifier.stat_changing, modifier)
		print(combatant, ": status effect removed modifier for ", StatTypes.new().stat_types_to_string[modifier.stat_changing], " ", modifier.value)
