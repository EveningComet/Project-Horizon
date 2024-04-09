## State for when the player is selecting an action for a character.
class_name PBSelectAction extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.get_pac().action_selected.connect( on_action_selected )
	my_state_machine.get_pac().open( my_state_machine.get_current_combatant() )
	
	if OS.is_debug_build() == true:
		print("PBSelectAction :: Entered.")

func exit() -> void:
	my_state_machine.get_pac().action_selected.disconnect( on_action_selected )
	my_state_machine.get_pac().close()

func check_for_unhandled_input(event: InputEvent) -> void:
	# If possible, go back to the previous character when the player presses
	# the responsible button
	if event.is_action_pressed("ui_cancel"):
		
		# Before anything, close out the battle skills menu
		if my_state_machine.get_pac().battle_skills_menu.is_visible() == true:
			my_state_machine.get_pac().close()
			my_state_machine.get_pac().open( my_state_machine.get_current_combatant() )
			return

## Activated when the player selects what their character wants to do.
func on_action_selected(new_action: StoredAction) -> void:
	my_state_machine.change_to_state("PBSelectTarget", {"stored_action" = new_action})
