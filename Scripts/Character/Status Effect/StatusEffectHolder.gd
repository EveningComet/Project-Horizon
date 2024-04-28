## Manages status effects for a character.
class_name StatusEffectHolder

## The character this is managing for.
var monitored_combatant: Combatant

## The current statuses and how many turns they have left.
## { status_effect : status_effect_combat_data }
var statuses: Dictionary = {}

func initialize(combatant: Combatant) -> void:
	monitored_combatant = combatant
	
func add_status_effect(status_to_add: StatusEffect) -> void:
	var combat_data := StatusEffectCombatData.new()
	combat_data.duration = status_to_add.duration_in_turns
	combat_data.on_apply_action_mediator = to_mediator(status_to_add.on_apply)
	combat_data.on_tick_action_mediator = to_mediator(status_to_add.on_turn_tick)
	combat_data.on_expire_action_mediator = to_mediator(status_to_add.on_expire)
	apply_if_not_null(combat_data.on_apply_action_mediator)
	statuses[status_to_add] = combat_data
	print(monitored_combatant, ": added status ", status_to_add.localization_name, " for ", status_to_add.duration_in_turns)

func apply_status_effect(status: StatusEffect) -> void:
	print(monitored_combatant, ": ticked status ", status.localization_name, " for ", status.duration_in_turns)
	var combat_data := statuses[status] as StatusEffectCombatData
	apply_if_not_null(combat_data.on_tick_action_mediator)
	combat_data.duration -= 1


func remove_status_effect(status_to_remove: StatusEffect) -> void:
	statuses.erase(status_to_remove)
	
func apply_if_not_null(action_mediator: ActionMediator):
	if (action_mediator != null):
		monitored_combatant.take_damage(action_mediator)
	
func to_mediator(data: StatusEffectData) -> ActionMediator:
	return null if data == null else data.to_mediator(monitored_combatant)
