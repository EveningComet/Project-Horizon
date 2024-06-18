## Responsible for displaying information to the player.
class_name Tooltip extends PanelContainer

@export_category("General")
## Some things will want to display an icon in the tooltip.
@export var icon_to_display: TextureRect

## The label that will display the name of the thing being focused/hovered.
## Could be things such as the character's name, an item name, and so on.
@export var title: Label

## Responsible for displaying some sort of description to the player. This could
## be an item's description, a skill's description, and so on.
@export var description_displayer: Label

@export var cost_value_label: Label

@export_category("Character Related")
## Used for displaying a character's level.
@export var level_value_displayer: Label

## Prefab that will be used to display changes in stats.
@export var stat_displayer: PackedScene

## UI node that will house the spawned stat text objects.
@export var stat_change_container: Container

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
	
	elif tooltip_data is SkillNode:
		handle_skill_node(tooltip_data as SkillNode)

## Performed when the player is not looking at something worthy of a tooltip.
func on_tooltip_hide() -> void:
	queue_free()

func handle_item_slot(item_slot: ItemSlotUI) -> void:
	if item_slot.item != null:
		var item: ItemData = item_slot.item
		title.set_text(item.localization_name)
		description_displayer.set_text(item.localization_description)
		description_displayer.show()
		cost_value_label.set_text( str(item.cost) )
		cost_value_label.get_parent().show()
		
		# If there is currently a character being inspected, display stat changes
		# for the relevant item
		var char_inspection_window: CharacterInspectionWindow = item_slot.character_inspection_window
		var curr_character: PlayerCombatant = char_inspection_window.current_character
		if char_inspection_window != null and curr_character != null and \
		item.item_type != ItemTypes.EquipmentTypes.None:
			
			var equipment_holder: EquipmentInventory = curr_character.equipment_holder
			if equipment_holder.has_item(item) == false:
				# For each modifier, create a text object displaying what stats
				# are changing
				for mod: StatModifier in item.stat_modifiers:
					create_stat_change_label(curr_character, mod)
					
				stat_change_container.get_parent().show()

func create_stat_change_label(character: Combatant, mod: StatModifier) -> void:
	var cds: CharacterStatDisplayer = stat_displayer.instantiate()
	var stat_name: String  = StatTypes.stat_types.keys()[mod.stat_changing]
	
	# Display the difference
	# TODO: Account for percentages.
	var diff: int = 0
	var original_value: int = character.stats[mod.stat_changing].get_calculated_value()
	var new_value: int      = original_value + mod.get_value()
	diff = original_value + new_value
	var change_symbol: String = "+" if diff >= original_value else "-"
	var stat_value: String  = change_symbol + str(mod.get_value())
	cds.update_display(stat_name, stat_value)
	
	stat_change_container.add_child(cds)

func handle_party_member_holder_ui(pmhui: PartyMemberHolderUI) -> void:
	var player_char: PlayerCombatant = pmhui.stored_character
	title.set_text(player_char.char_name)
	level_value_displayer.set_text(str(player_char.curr_level))
	level_value_displayer.get_parent().show()

func handle_skill_node(skill_node: SkillNode) -> void:
	var skill_instance: SkillInstance = skill_node.skill_instance
	title.set_text(skill_instance.skill.localization_name)
	description_displayer.set_text(skill_instance.skill.localization_description)
	description_displayer.show()
	
	var curr: int = skill_instance.curr_rank
	var max:  int = skill_instance.skill.max_rank
	upgrade_displayer.set_text( "%s / %s" % [curr, max])
	upgrade_displayer.show()
