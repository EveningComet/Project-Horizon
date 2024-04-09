## Entered when a battle starts.
class_name BattleStart extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	setup_battle()
	
	if OS.is_debug_build() == true:
		print("BattleStart :: Entered.")

func setup_battle() -> void:
	# Refresh the death handler
	my_state_machine.death_handler.refresh()
	
	# Spawn the necessary characters.
	spawn_player_characters()
	spawn_enemies()
	
	# TODO: Find a way to prevent having to wait- overcome the race condition.
	await get_tree().create_timer(1.0).timeout
	
	# The battle can now begin
	my_state_machine.change_to_state("PlayerTurn")

func spawn_player_characters() -> void:
	# Add the player's party to the battle
	for player_character: PlayerCombatant in PlayerPartyController.party_members:
		player_character.reparent( my_state_machine.spawned_combatants_node )
		my_state_machine.player_battle_hud.create_hud_for_pc( player_character )
		
		# Make the state machine keep track of the character
		my_state_machine.add_combatant( player_character )
		
		# Fire the event to create UI for the character
		EventBus.combatant_spawned_in_battle.emit( player_character )

func spawn_enemies() -> void:
	for enemy_data in MissionController.current_mission.enemies:
		var enemy_combatant = make_enemy( enemy_data )
		my_state_machine.add_combatant( enemy_combatant )
		my_state_machine.spawned_combatants_node.add_child( enemy_combatant )
		EventBus.combatant_spawned_in_battle.emit( enemy_combatant )
		if OS.is_debug_build() == true:
			print("BattleStart :: Added enemy Vitality=", enemy_combatant.vitality,
				", Expertise=", enemy_combatant.expertise,
				", Will=", enemy_combatant.will)

func make_enemy(enemy_data: EnemyData) -> EnemyCombatant:
	var enemy_combatant = EnemyCombatant.new()
	enemy_combatant.vitality = enemy_data.vitality
	enemy_combatant.expertise = enemy_data.expertise
	enemy_combatant.will = enemy_data.will
	return enemy_combatant
