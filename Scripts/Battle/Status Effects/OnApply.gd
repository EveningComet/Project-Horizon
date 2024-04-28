## When status effect is applied
class_name OnApply extends StatusEffectState

func enter(msgs: Dictionary = {}) -> void:
	var effect := my_state_machine.status_effect as StatusEffect
	var receiver := my_state_machine.receiver as Combatant
	var mediator := my_state_machine.action_mediator as ActionMediator
	mediator.damage_data[StatTypes.DamageTypes.Base] = effect.on_apply.damage_to_inflict
	print("Enter :: ", effect.localization_name, " inflicted ", mediator.damage_data[StatTypes.DamageTypes.Base], " damage")

func exit() -> void:
	pass
