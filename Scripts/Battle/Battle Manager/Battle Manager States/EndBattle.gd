## Responsible for ending a battle.
class_name EndBattle extends BattleState

@export_file("*tscn") var homebase_home_scene: String

func enter(msgs: Dictionary = {}) -> void:
	print("EndBattle :: Entered.")
	match msgs:
		{"player_victory": var player_victory, "experience_points_to_reward": var xp}:
			if player_victory == true:
				victory(xp)
			else:
				defeat()

func exit() -> void:
	pass

func victory(xp_to_reward: int) -> void:
	# TODO: Dish out experience based on the defeated enemies.
	
	# Transfer any stat changes to the player's party
	
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)

func defeat() -> void:
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)
	pass
