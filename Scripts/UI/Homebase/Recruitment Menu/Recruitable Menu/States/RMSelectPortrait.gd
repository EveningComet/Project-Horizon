## State where the player selects a visual representation for a new character.
class_name RMSelectPortrait extends RecruitableMenuState

@export var portrait_displayer_button_template: PackedScene

func enter(msgs: Dictionary = {}) -> void:
	# TODO: Allow the player to select portraits from other classes.
	
	# Create selectable versions of the portraits
	for pd: PortraitData in my_state_machine.starting_class.get_portraits():
		var pdb: PortraitDisplayerButton = portrait_displayer_button_template.instantiate()
		pdb.portrait_data = pd
		pdb.portrait_selected.connect( on_portrait_data_selected )
		pdb.display_icon.set_texture( pd.big_portrait )
		my_state_machine.portraits_container.add_child(pdb)
	
	# TODO: Another race condition here. Figure out how to remove this.
	await get_tree().create_timer(0.01).timeout
	my_state_machine.portraits_container.show()
	my_state_machine.portraits_container.get_child(0).grab_focus()

func exit() -> void:
	for pdb: PortraitDisplayerButton in my_state_machine.portraits_container.get_children():
		pdb.portrait_selected.disconnect( on_portrait_data_selected )
		pdb.queue_free()
	my_state_machine.portraits_container.hide()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("RMSelectClass")

func on_portrait_data_selected(pd: PortraitData) -> void:
	my_state_machine.created_character.portrait_data = pd
	my_state_machine.change_to_state("RMEnterName")
