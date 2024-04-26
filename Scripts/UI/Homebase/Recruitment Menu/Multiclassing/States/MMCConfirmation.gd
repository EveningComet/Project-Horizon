## The state where the player confirms or denies the multiclass.
class_name MMCConfirmation extends MMCState

@export var confirmation_menu_holder: Container
@export var confimation_button_holder: Container

@export var confirmation_dialog: Label
@export var confirm_button: Button
@export var cancel_button:  Button

func enter(msgs: Dictionary = {}) -> void:
	display()

func exit() -> void:
	close_out()

func display() -> void:
	confirm_button.button_down.connect(on_confirm_button_pressed)
	cancel_button.button_down.connect(on_cancel_button_pressed)
	
	var dialog_text: String = "Are you sure? %s will multiclass into: %s." % [
		my_state_machine.tracked_character.char_name,
		my_state_machine.class_to_add.localization_name
	]
	confirmation_dialog.set_text( dialog_text )
	
	confirmation_menu_holder.show()
	confimation_button_holder.get_child(1).grab_focus()

func close_out() -> void:
	confirm_button.button_down.disconnect(on_confirm_button_pressed)
	cancel_button.button_down.disconnect(on_cancel_button_pressed)
	confirmation_menu_holder.hide()

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		on_cancel_button_pressed()

func on_confirm_button_pressed() -> void:
	my_state_machine.tracked_character.set_pc_class(
		my_state_machine.class_to_add
	)
	my_state_machine.tracked_character = null
	my_state_machine.class_to_add      = null
	my_state_machine.change_to_state("MMCInactive")

func on_cancel_button_pressed() -> void:
	my_state_machine.change_to_state("MMCAddClass")
