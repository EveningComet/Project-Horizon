## State for when the player is selecting an action for a character.
class_name PBSelectAction extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.get_pac().attack_button_pressed.connect( on_attack_button_pressed )
	my_state_machine.get_pac().defend_button_pressed.connect( on_defend_button_pressed )
	my_state_machine.get_pac().open( my_state_machine.get_current_combatant() )
	
	print("PBSelectAction :: Entered.")

func exit() -> void:
	my_state_machine.get_pac().attack_button_pressed.disconnect( on_attack_button_pressed )
	my_state_machine.get_pac().defend_button_pressed.disconnect( on_defend_button_pressed )
	my_state_machine.get_pac().close()

func check_for_unhandled_input(event: InputEvent) -> void:
	# If possible, go back to the previous character when the player presses
	# the responsible button
	if event.is_action_pressed("ui_cancel"):
		
		# Before anything, close out the battle skills menu
		if my_state_machine.get_pac().battle_skills_menu.is_visible() == true:
			my_state_machine.get_pac().close_battle_skills_menu()
			my_state_machine.get_pac().open( my_state_machine.get_current_combatant() )
			return
		print("PBSelectAction :: Player pressed back button. Checking if we can go to a previous character.")

## In the event that the player presses the attack button for the current
## character, create a stored action and pass it along using
func on_attack_button_pressed() -> void:
	print("PBSelectAction :: Player has selected attack for the current character.")
	# TODO: Cleanup.
	var stored_action: StoredAction = StoredAction.new(
		my_state_machine.get_current_combatant(), 
		ActionTypes.ActionTypes.SingleEnemy
	)
	my_state_machine.change_to_state("PBSelectTarget", {stored_action = stored_action})

func on_defend_button_pressed() -> void:
	print("PBSelectAction :: Player has selected defend for the current character.")
	# TODO: Cleanup.
	var stored_action: StoredAction = StoredAction.new(
		my_state_machine.get_current_combatant(),
		ActionTypes.ActionTypes.Defend
	)
	my_state_machine.change_to_state("PBSelectTarget", {stored_action = stored_action})

func on_run_button_pressed() -> void:
	# TODO: Handle running away.
	pass
