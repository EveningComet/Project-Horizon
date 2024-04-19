## State for where the player enters a name for their character.
class_name RMEnterName extends RecruitableMenuState

## Used to enter the character's name.
@export var character_name_entry: CharacterNameInputScreen

func enter(msgs: Dictionary = {}) -> void:
	character_name_entry.start_accepting_input(
		my_state_machine.created_character
	)
	character_name_entry.player_finished_entering_name.connect(
		on_player_finished_entering_name
	)
	
func exit() -> void:
	character_name_entry.close()
	character_name_entry.player_finished_entering_name.disconnect(
		on_player_finished_entering_name
	)

func check_for_unhandled_input(event: InputEvent) -> void:
	# TODO: Once the portrait selection is properly implmented, return to that.
	# TODO: If we allow gamepads for name entry, this might cause problems.
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("RMSelectClass")
		return

## When the player finishes entering the name for their created character,
## see what has to be done. If the player's party has space, the created character
## will be added.
func on_player_finished_entering_name() -> void:
	
	# Add the character to the party if there is a spot left
	# TODO: Notify the player that the character has been added to their party.
	my_state_machine.created_character.reparent( PlayerPartyController )
	if PlayerPartyController.get_party_count() < PlayerPartyController.MAX_RECRUITABLE_SIZE:
		PlayerPartyController.add_party_member( my_state_machine.created_character )
	
	# Set the starting equipment
	for i: int in my_state_machine.starting_class.starting_equipment.size():
		var item_slot_data: ItemSlotData = ItemSlotData.new()
		item_slot_data.stored_item = my_state_machine.starting_class.starting_equipment[i]
		item_slot_data.quantity = 1
		my_state_machine.created_character.equipment_holder.drop_slot_data(item_slot_data, i)
	
	character_name_entry.close()
	my_state_machine.created_character  = null
	my_state_machine.starting_class     = null
	
	# Return to the class selection
	my_state_machine.change_to_state("RMSelectClass")
