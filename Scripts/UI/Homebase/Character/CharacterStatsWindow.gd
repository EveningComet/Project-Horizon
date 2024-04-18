## Displays a party member, their current stat values, and their equipment.
class_name CharacterInspectionWindow extends Control

@export var char_name_label: Label
@export var character_class_name_label: Label

@export var equipment_displayer: InventoryDisplayer

## The current character being tracked.
var current_character: PlayerCombatant = null:
	get:
		return current_character
	set(value):
		# Unsub the old character
		if current_character != null:
			current_character.stat_changed.disconnect( on_stat_changed )
		
		current_character = value
		equipment_displayer.set_inventory_to_display(
			current_character.equipment_holder
		)
		current_character.stat_changed.connect( on_stat_changed )
		on_stat_changed( current_character )

## When a character's stats change, update the relevant information.
func on_stat_changed(combatant: PlayerCombatant) -> void:
	char_name_label.set_text( combatant.char_name )
	character_class_name_label.set_text( combatant.pc_class.localization_name )
	$"Stats Container".get_child(0).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Vitality],
		str( floor(combatant.stats[StatTypes.stat_types.Vitality].get_calculated_value()) )
	)
