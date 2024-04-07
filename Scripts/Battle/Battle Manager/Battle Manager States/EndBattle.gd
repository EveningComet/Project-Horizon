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
	# Put the party back where it belongs
	for party_member: PlayerCombatant in PlayerPartyController.party_members:
		party_member.reparent( PlayerPartyController )
	
	# Dish out experience based on the defeated enemies.
	for pm: PlayerCombatant in PlayerPartyController.party_members:
		pm.gain_experience( xp_to_reward )
	
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)

func defeat() -> void:
	# Leave the battle scene
	SceneController.switch_to_scene(homebase_home_scene)
