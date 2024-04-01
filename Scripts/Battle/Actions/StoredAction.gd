## Stores an action for a character in battle. When that character's turn in
## battle arrives, the data from here will be used to execute
## what that character should do.
class_name StoredAction

## The activator of the action.
var activator: Combatant

## Used to easily tell things what this action is doing.
var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy

## When a character is using an ability/skill.
var skill_data: SkillData

## The target or targets that is the receiver of the activator.
var recipients: Array[Combatant] = []

func _init(activator_to_store: Combatant, new_action_type: ActionTypes.ActionTypes):
	activator   = activator_to_store
	action_type = new_action_type

func get_targets() -> Array[Combatant]:
	return recipients
	
func set_activator(new_activator: Combatant) -> void:
	activator = new_activator

func set_action_type(new_action_type: ActionTypes.ActionTypes) -> void:
	action_type = new_action_type
	
func set_targets(targets: Array[Combatant]) -> void:
	recipients.append_array( targets )

