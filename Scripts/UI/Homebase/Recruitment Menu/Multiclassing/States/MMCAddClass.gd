## The state where the player selects the class to add for their character.
class_name MMCAddClass extends MMCState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.class_to_add = null
	display_classes()

func exit() -> void:
	close_out()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("MMCSelectCharacter")

func close_out() -> void:
	for ccb: CharacterClassButton in my_state_machine.button_holder.get_children():
		ccb.player_highlighted_character_class_button.disconnect(
			on_player_highlighted_char_class_button
		)
		ccb.player_selected_class.disconnect(on_class_selected)
		ccb.queue_free()
	
	my_state_machine.button_holder.hide()
	my_state_machine.class_description_holder.hide()
	my_state_machine.class_description_label.set_text("")

func display_classes() -> void:
	for cc: CharacterClass in my_state_machine.potential_classes:
		var char_class_button: CharacterClassButton
		char_class_button = my_state_machine.char_class_button_prefab.instantiate()
		char_class_button.setup_button(cc)
		my_state_machine.button_holder.add_child( char_class_button )
		char_class_button.player_highlighted_character_class_button.connect(
			on_player_highlighted_char_class_button
		)
		char_class_button.player_selected_class.connect(
			on_class_selected
		)
		
		# Don't allow the player character to select a class they already are
		if my_state_machine.tracked_character.pc_classes.has(cc) == true:
			char_class_button.disabled = true
	
	# TODO: Another race condition here. Figure out how to remove this.
	await get_tree().create_timer(0.01).timeout
	my_state_machine.class_description_holder.show()
	my_state_machine.button_holder.show()
	var first_active_button: CharacterClassButton
	for c: CharacterClassButton in my_state_machine.button_holder.get_children():
		if c.disabled == false:
			first_active_button = c
			break
	first_active_button.grab_focus()

func on_player_highlighted_char_class_button(new_class: CharacterClass) -> void:
	my_state_machine.class_description_label.set_text(
		new_class.localization_description
	)

func on_class_selected(new_class: CharacterClass) -> void:
	my_state_machine.class_to_add = new_class
	my_state_machine.change_to_state("MMCConfirmation")
