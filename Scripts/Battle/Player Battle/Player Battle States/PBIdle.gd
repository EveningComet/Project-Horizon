## When the player is waiting for their turn.
class_name PBIdle extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	EventBus.begin_player_turn.connect( on_player_turn_started )
	if OS.is_debug_build() == true:
		print("PBIdle :: Entered.")

func exit() -> void:
	EventBus.begin_player_turn.disconnect( on_player_turn_started )

## Fired when the player's turn starts.
func on_player_turn_started() -> void:
	my_state_machine.setup_for_new_turn()
	my_state_machine.change_to_state("PBSelectAction")
