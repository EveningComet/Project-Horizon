## Displays a party member, their current stat values, and their equipment.
class_name CharacterInspectionWindow extends Control

@export var char_name_label: Label
@export var character_class_name_label: Label
@export var portrait_displayer: PortraitDisplayer

@export var equipment_displayer: InventoryDisplayer

# Buttons for swapping between the currently displayed party member
@export var swap_right_button: Button
@export var swap_left_button:  Button

@export var stats_container: Container

signal displayed_character_changed(new_character_to_display: PlayerCombatant)

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
		portrait_displayer.display_icon.set_texture(
			current_character.portrait_data.small_portrait
		)
		current_character.stat_changed.connect( on_stat_changed )
		displayed_character_changed.emit( current_character )
		on_stat_changed( current_character )

func _unhandled_input(event: InputEvent) -> void:
	if visible == true and PlayerPartyController.has_members() == true:
		# Handle swapping between characters in the menu
		if event.is_action_pressed("swap_right"):
			if current_character != null:
				var index: int = PlayerPartyController.party_members.find( current_character )
				on_swap_right( index )
		
		elif event.is_action_pressed("swap_left"):
			if current_character != null:
				var index: int = PlayerPartyController.party_members.find( current_character )
				on_swap_left( index )

func _ready() -> void:
	swap_left_button.button_down.connect( on_button_swap_left )
	swap_right_button.button_down.connect( on_button_swap_right )
	
	if PlayerPartyController.has_members() == true:
		current_character = PlayerPartyController.party_members[0]
		show()
	else:
		hide()

func on_button_swap_right() -> void:
	if current_character == null:
		return
	var curr_index = PlayerPartyController.party_members.find( current_character )
	on_swap_right( curr_index )

func on_swap_right(curr_index: int) -> void:
	curr_index += 1
	if curr_index > PlayerPartyController.get_party_count() - 1:
		curr_index = 0
	if current_character != PlayerPartyController.party_members[curr_index]:
		current_character = PlayerPartyController.party_members[curr_index]

func on_button_swap_left() -> void:
	if current_character == null:
		return
	var curr_index = PlayerPartyController.party_members.find( current_character )
	on_swap_left( curr_index )

func on_swap_left(curr_index: int) -> void:
	curr_index -= 1
	if curr_index < 0:
		curr_index = PlayerPartyController.get_party_count() - 1
	if current_character != PlayerPartyController.party_members[curr_index]:
		current_character = PlayerPartyController.party_members[curr_index]

## When a character's stats change, update the relevant information.
func on_stat_changed(combatant: PlayerCombatant) -> void:
	char_name_label.set_text( combatant.char_name )
	character_class_name_label.set_text( combatant.pc_class().localization_name )
	
	# TODO: Figure out a nicer way to do this. I tried looping through the stats
	# dictionary and it didn't work as expected
	stats_container.get_child(0).update_display(
		"Level",
		str( combatant.curr_level )
	)
	stats_container.get_child(1).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Vitality],
		str( floor(combatant.stats[StatTypes.stat_types.Vitality].get_calculated_value()) )
	)
	stats_container.get_child(2).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Expertise],
		str( floor(combatant.stats[StatTypes.stat_types.Expertise].get_calculated_value()) )
	)
	stats_container.get_child(3).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Will],
		str( floor(combatant.stats[StatTypes.stat_types.Will].get_calculated_value()) )
	)
	stats_container.get_child(4).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Defense],
		str( floor(combatant.get_defense()) )
	)
	stats_container.get_child(5).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.PhysicalPower],
		str( floor(combatant.get_physical_power()) )
	)
	stats_container.get_child(6).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.SpecialPower],
		str( floor(combatant.get_special_power()) )
	)
	stats_container.get_child(7).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.Speed],
		str( floor(combatant.get_speed()) )
	)
	stats_container.get_child(8).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.MaxHP],
		str( combatant.get_max_hp() )
	)
	stats_container.get_child(9).update_display(
		StatTypes.stat_types.keys()[StatTypes.stat_types.MaxSP],
		str( combatant.get_max_sp() )
	)
