## When the recruitable menu is inactive.
class_name RMInactive extends RecruitableMenuState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.recruitable_menu_node.hide()
	my_state_machine.recruitable_menu_node.visibility_changed.connect(
		on_visibility_changed
	)

func exit() -> void:
	my_state_machine.recruitable_menu_node.visibility_changed.disconnect(
		on_visibility_changed
	)

func on_visibility_changed() -> void:
	if my_state_machine.recruitable_menu_node.visible == true:
		my_state_machine.change_to_state("RMSelectClass")
