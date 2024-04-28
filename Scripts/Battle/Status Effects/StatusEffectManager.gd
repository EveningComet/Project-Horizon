## State machine responsible for handling a status effect
class_name StatusEffectManager extends StateMachine

var receiver: Combatant
var status_effect: StatusEffect
var action_mediator: ActionMediator

func set_me_up() -> void:
	super()

func apply(target: Combatant, effect: StatusEffect, mediator: ActionMediator):
	receiver = target
	status_effect = effect
	action_mediator = mediator
	change_to_state("TryApplyEffect")
