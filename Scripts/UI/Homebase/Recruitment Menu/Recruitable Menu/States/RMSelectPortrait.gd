## State where the player selects a visual representation for a new character.
class_name RMSelectPortrait extends RecruitableMenuState

func enter(msgs: Dictionary = {}) -> void:
	# TODO: Properly implement this state. For now, just jump to name entry.
	my_state_machine.change_to_state("RMEnterName")
