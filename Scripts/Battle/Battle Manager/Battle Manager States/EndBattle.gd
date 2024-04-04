## Responsible for ending a battle.
class_name EndBattle extends BattleState

@export_file("*tscn") var homebase_home_scene: String

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("EndBattle :: Entered.")
	
	match msgs:
		{"player_victory": var player_victory, "experience_points_to_reward": var xp}:
			if player_victory == true:
				victory( xp )
			else:
				defeat()

func exit() -> void:
	pass

func victory(xp_to_reward: int) -> void:
	# Dish out experience based on the defeated enemies.
	for pm: PlayerCombatant in PlayerPartyController.get_children():
		pm.gain_experience( xp_to_reward )
	
	# Transfer any stat changes to the player's party from their batle copies
	
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)

func defeat() -> void:
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)
