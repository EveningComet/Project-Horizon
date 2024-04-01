## Responsible for ending a battle.
class_name EndBattle extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'result': var player_victory}:
			if player_victory == true:
				victory()
			else:
				defeat()
	
	print("EndBattle :: Entered.")

func victory() -> void:
	# TODO: Dish out experience based on the defeated enemies.
	
	# Leave the battle scene
	pass

func defeat() -> void:
	# Leave the battle scene
	pass
