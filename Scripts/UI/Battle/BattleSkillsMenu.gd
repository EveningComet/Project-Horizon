## Responsible for displaying the skills a character can currently use in battle
## to the player.
class_name BattleSkillsMenu extends Control

@export var battle_skill_button_template: PackedScene

## The node that houses the spawned buttons.
@export var spawned_button_node: Control

## The node handling the description of a skill to the player.
@export var description: Label

## The player character that will have their usable skills displayed.
var skill_user: PlayerCombatant = null

func _ready() -> void:
	close()

## Display the skills of the passed character to the player.
func open(user_to_display: PlayerCombatant) -> void:
	skill_user = user_to_display
	
	# Spawn a selectable button for each usable skill
	print("BattleSkillsMenu :: Skills for character: ", skill_user.available_skills)
	for skill in skill_user.available_skills:
		if skill.is_passive == false:
			var b: BattleSkillMenuButton = battle_skill_button_template.instantiate() as BattleSkillMenuButton
			b.set_skill( skill )
			spawned_button_node.add_child( b )
	
	# Finally, display to the player.
	show()

func close() -> void:
	skill_user = null
	
	# Delete all the spawned buttons
	if spawned_button_node.get_child_count() > 0:
		for c in spawned_button_node.get_children():
			c.queue_free()
	
	# Finally, hide the menu
	hide()
