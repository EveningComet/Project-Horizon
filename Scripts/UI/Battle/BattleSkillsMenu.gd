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

func set_skill_user(new_user: PlayerCombatant) -> void:
	skill_user = new_user
	for skill_instance: SkillInstance in skill_user.skill_holder.skills():
		if skill_instance.monitored_skill.is_passive == false:
			var b: BattleActionButton = battle_skill_button_template.instantiate() as BattleActionButton
			b.skill_instance = skill_instance
			spawned_button_node.add_child( b )
			# TODO: Proper disabling based on the cost.
			b.disabled = skill_user.stats[StatTypes.stat_types.CurrentSP] < skill_instance.monitored_skill.cost
			b.skill_button_highlighted.connect( on_skill_button_highlighted )

	if OS.is_debug_build() == true:
		print("BattleSkillsMenu :: Skills for character: ", skill_user.skill_holder.skills())

## Display the skills of the passed character to the player.
func open() -> void:
	spawned_button_node.get_child(0).grab_focus()
	show()

func close() -> void:
	skill_user = null
	
	# Delete all the spawned buttons
	if spawned_button_node.get_child_count() > 0:
		for c: BattleActionButton in spawned_button_node.get_children():
			c.skill_button_highlighted.disconnect( on_skill_button_highlighted )
			c.queue_free()
	
	# Finally, hide the menu
	hide()

## Update the description when the player has focused a skill button in some way.
func on_skill_button_highlighted(si: SkillInstance) -> void:
	description.set_text(si.monitored_skill.localization_description)
	# TODO: Display the needed info like power output.
