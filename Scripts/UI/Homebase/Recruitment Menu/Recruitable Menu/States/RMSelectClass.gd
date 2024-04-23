## The state where the player can select the class for their character.
class_name RMSelectClass extends RecruitableMenuState

func enter(msgs: Dictionary = {}) -> void:
	if my_state_machine.created_character != null:
		my_state_machine.created_character.queue_free()
		my_state_machine.created_character = null
		my_state_machine.starting_class    = null
	
	my_state_machine.portraits_container.show()
	display_classes( my_state_machine.character_classes )

func exit() -> void:
	my_state_machine.portraits_container.hide()
	close_out()

func check_for_unhandled_input(event: InputEvent) -> void:
	# The player wants to leave, so allow returning to the main
	# recruitable menu
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("RMInactive")

func display_classes(pc_classes: Array[CharacterClass]) -> void:
	for pc_class: CharacterClass in pc_classes:
		var char_class_button: CharacterClassButton = my_state_machine.character_class_button_template.instantiate()
		char_class_button.setup_button( pc_class )
		char_class_button.player_highlighted_character_class_button.connect(
			on_player_highlighted_character_class_button
		)
		char_class_button.player_selected_class.connect( on_class_selected )
		my_state_machine.class_container.add_child( char_class_button )
	
	my_state_machine.class_container.show()
	my_state_machine.class_description_holder.show()
	my_state_machine.class_container.get_child(0).grab_focus()

func close_out() -> void:
	for child: CharacterClassButton in my_state_machine.class_container.get_children():
		child.player_selected_class.disconnect( on_class_selected )
		child.player_highlighted_character_class_button.disconnect(
			on_player_highlighted_character_class_button
		)
		child.queue_free()
	
	my_state_machine.class_description_holder.hide()
	my_state_machine.class_container.hide()

func on_player_highlighted_character_class_button(pc_class: CharacterClass) -> void:
	my_state_machine.class_description_label.set_text(
		pc_class.localization_description
	)
	
	var portraits_container = my_state_machine.portraits_container
	for c in portraits_container.get_children():
		c.queue_free()
	
	# Show the portraits of the class in the background
	var portraits: Array[PortraitData] = pc_class.get_portraits()
	var pd_template = preload("res://Scenes/UI/Homebase/Portrait Displayer.tscn")
	for portrait in portraits:
		var portrait_displayer: PortraitDisplayer = pd_template.instantiate()
		portrait_displayer.portrait_data = portrait
		portraits_container.add_child(portrait_displayer)
		portrait_displayer.display_icon.set_texture(
			portrait_displayer.portrait_data.big_portrait
		)

func on_class_selected(pc_class: CharacterClass) -> void:
	var new_character: PlayerCombatant = PlayerCombatant.new()
	new_character.set_pc_class( pc_class )
	my_state_machine.created_character = new_character
	my_state_machine.starting_class    = pc_class
	my_state_machine.add_child( new_character )
	
	# Move onto the next state
	my_state_machine.change_to_state("RMSelectPortrait")
