## For when the multiclassing menu is not active.
class_name MMCInactive extends MMCState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.multiclassing_menu_ui_node.hide()
	my_state_machine.multiclassing_menu_ui_node.visibility_changed.connect(
		on_visibility_changed
	)

func exit() -> void:
	my_state_machine.multiclassing_menu_ui_node.visibility_changed.disconnect(
		on_visibility_changed
	)

func on_visibility_changed() -> void:
	if my_state_machine.multiclassing_menu_ui_node.visible == true:
		my_state_machine.change_to_state("MMCSelectCharacter")
