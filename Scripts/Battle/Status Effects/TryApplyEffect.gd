## When status effect is applied
class_name TryApplyEffect extends StatusEffectState


var prng: RandomNumberGenerator = RandomNumberGenerator.new()


func enter(msgs: Dictionary = {}) -> void:
	var generated_number = prng.randf_range(0.0, 1.0)
	var effect := my_state_machine.status_effect as StatusEffect
	var mediator := my_state_machine.action_mediator as ActionMediator
	if (generated_number <= mediator.status_effects_to_apply[effect]):
		my_state_machine.change_to_state("OnApply")
	else:
		my_state_machine.change_to_state("EffectInactive")
	

func exit() -> void:
	pass
