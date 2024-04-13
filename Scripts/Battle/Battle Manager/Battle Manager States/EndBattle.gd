## Responsible for ending a battle.
class_name EndBattle extends BattleState

@export_file("*tscn") var homebase_home_scene: String

@export var battle_results_screen: BattleResultsScreen

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("EndBattle :: Entered.")
	
	# Put the party back where it belongs
	for party_member: PlayerCombatant in PlayerPartyController.party_members:
		party_member.reparent( PlayerPartyController )
	
	match msgs:
		{"player_victory": var player_victory, "experience_points_to_reward": var xp}:
			if player_victory == true:
				victory( xp )
			else:
				defeat()
		# TODO: Handle fleeing.

func exit() -> void:
	pass

func victory(xp_to_reward: int) -> void:
	# Mark the current mission as completed
	MissionController.unlock_next_mission( MissionController.current_mission )
	
	battle_results_screen.activate( true, false, xp_to_reward )

func defeat() -> void:
	battle_results_screen.activate( false, false, 0 )
