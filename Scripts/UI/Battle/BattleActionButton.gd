## Used to help with setting actions for the player's characters.
class_name BattleActionButton extends Button

signal action_button_pressed(action_button: BattleActionButton)

@export var action_type: ActionTypes.ActionTypes = ActionTypes.ActionTypes.SingleEnemy
@export var skill: SkillData = null:
	get:
		return skill
	set(value):
		skill = value
		if skill != null:
			text        = skill.localization_name
			action_type = skill.action_type

func _ready() -> void:
	pressed.connect( on_pressed )

func on_pressed() -> void:
	action_button_pressed.emit( self )
