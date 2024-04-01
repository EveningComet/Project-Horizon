## When the player is waiting for their turn.
class_name PBIdle extends PlayerBattleState

func enter(msgs: Dictionary = {}) -> void:
	print("PBIdle :: Entered.")

func exit() -> void:
	pass
