## State for where the player selects the character for multiclassing.
class_name MMCSelectCharacter extends MMCState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.tracked_character = null
	display_characters()

func exit() -> void:
	close_out()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("MMCInactive")

func close_out() -> void:
	for c: MMCPCButton in my_state_machine.button_holder.get_children():
		c.character_selected_for_multiclassing.disconnect( on_character_selected )
		c.queue_free()
		
	my_state_machine.button_holder.hide()

func display_characters() -> void:
	# Create buttons for each of the party members and store a reference to them
	for pm: PlayerCombatant in PlayerPartyController.party_members:
		var mmpcb: MMCPCButton = my_state_machine.mmcpc_button_prefab.instantiate()
		my_state_machine.button_holder.add_child( mmpcb )
		mmpcb.character_selected_for_multiclassing.connect(
			on_character_selected
		)
		mmpcb.stored_character = pm
	
	my_state_machine.button_holder.show()
	my_state_machine.button_holder.get_child(0).grab_focus()

func on_character_selected(player_c: PlayerCombatant) -> void:
	my_state_machine.tracked_character = player_c
	my_state_machine.change_to_state("MMCAddClass")
