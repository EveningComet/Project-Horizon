## State where the player selects a visual representation for a new character.
class_name RMSelectPortrait extends RecruitableMenuState

func enter(msgs: Dictionary = {}) -> void:
	# TODO: Properly implement this state. For now, just jump to name entry.
	# TODO: Allow the player to select portraits from other classes.
	my_state_machine.portraits_container.show()
	my_state_machine.change_to_state("RMEnterName")

func exit() -> void:
	my_state_machine.portraits_container.hide()
