## When the player is waiting for their turn.
class_name PBIdle extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("PBIdle :: Entered.")
	pass

func exit() -> void:
	pass
