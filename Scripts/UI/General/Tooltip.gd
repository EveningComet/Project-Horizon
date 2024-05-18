## Responsible for displaying information to the player.
class_name Tooltip extends PanelContainer

## Some things will want to display an icon in the tooltip.
@export var icon_to_display: TextureRect

## The label that will display the name of the thing being focused/hovered.
## Could be things such as the character's name, an item name, and so on.
@export var title: Label

## Used for displaying a character's level.
@export var level_value_displayer: Label

## Responsible for displaying some sort of description to the player. This could
## be an item's description, a skill's description, and so on.
@export var description_displayer: Label

## For skills.
@export var upgrade_displayer: Label

## Properly update what should be displayed based on the focus/mouseover.
func on_tooltip_display(tooltip_data: Control) -> void:
	# Display the relevant item info
	if tooltip_data is ItemSlotUI:
		handle_item_slot(tooltip_data as ItemSlotUI)
	
	# Display information related to a character being hovered over in the
	# party management menu
	elif tooltip_data is PartyMemberHolderUI:
		handle_party_member_holder_ui(tooltip_data as PartyMemberHolderUI)
	
	elif tooltip_data is SkillTreeButton:
		handle_skill_button(tooltip_data as SkillTreeButton)

func on_tooltip_hide() -> void:
	queue_free()

func handle_item_slot(item_slot: ItemSlotUI) -> void:
	title.set_text(item_slot.item.localization_name)
	description_displayer.set_text(item_slot.item.localization_description)
	
	# If there is currently a character being inspected, display their stats
	var char_inspection_window: CharacterInspectionWindow = item_slot.character_inspection_window
	if char_inspection_window != null and char_inspection_window.current_character != null:
		if OS.is_debug_build() == true:
			print("Tooltip :: There is a character. Stat changes should be displayed.")
	
	description_displayer.show()

func handle_party_member_holder_ui(pmhui: PartyMemberHolderUI) -> void:
	var player_char: PlayerCombatant = pmhui.stored_character
	title.set_text(player_char.char_name)
	level_value_displayer.set_text(str(player_char.curr_level))
	level_value_displayer.get_parent().show()

func handle_skill_button(skill_button: SkillTreeButton) -> void:
	var skill_instance: SkillInstance = skill_button.skill
	title.set_text(skill_instance.monitored_skill.localization_name)
	description_displayer.set_text(skill_instance.monitored_skill.localization_description)
	description_displayer.show()
	
	if skill_instance.monitored_skill.max_rank > 1:
		var curr: int = skill_instance.current_upgrade_level
		var max:  int = skill_instance.monitored_skill.max_rank
		upgrade_displayer.set_text( "%s / %s" % [curr, max])
		upgrade_displayer.show()
