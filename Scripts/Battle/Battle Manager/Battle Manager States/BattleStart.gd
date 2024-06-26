## Entered when a battle starts.
class_name BattleStart extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	setup_battle()
	
	if OS.is_debug_build() == true:
		print("BattleStart :: Entered.")

func setup_battle() -> void:
	# Refresh the death handler
	my_state_machine.death_handler.refresh()
	
	# These events have to be connected here due to race conditions
	EventBus.combatant_spawned_in_battle.connect( my_state_machine.death_handler.on_combatant_spawned )
	EventBus.combatant_spawned_in_battle.connect( my_state_machine.player_battle_hud.on_combatant_spawned_in_combat )
	EventBus.combatant_spawned_in_battle.connect( my_state_machine.enemy_battle_hud.on_combatant_spawned_in_combat )
	
	# Spawn the necessary characters.
	spawn_player_characters()
	spawn_enemies()
	
	setup_audio()
	
	# TODO: Find a way to prevent having to wait- overcome the race condition.
	await get_tree().create_timer(1.0).timeout
	
	# The battle can now begin
	my_state_machine.change_to_state("PlayerTurn")

func spawn_player_characters() -> void:
	# Add the player's party to the battle
	for player_character: PlayerCombatant in PlayerPartyController.party_members:
		player_character.add_to_group( my_state_machine.PLAYER_GROUP_NAME )
		player_character.reparent( my_state_machine.spawned_combatants_node )
		
		# Make the state machine keep track of the character
		my_state_machine.add_combatant( player_character )
		
		# Fire the event to create UI for the character
		EventBus.combatant_spawned_in_battle.emit( player_character )

func spawn_enemies() -> void:
	for enemy_data in MissionController.current_mission.enemies:
		var enemy_combatant = make_enemy( enemy_data )
		enemy_combatant.add_to_group( my_state_machine.ENEMY_GROUP_NAME )
		my_state_machine.add_combatant( enemy_combatant )
		my_state_machine.spawned_combatants_node.add_child( enemy_combatant )
		EventBus.combatant_spawned_in_battle.emit( enemy_combatant )

func make_enemy(enemy_data: EnemyData) -> EnemyCombatant:
	var enemy_combatant = EnemyCombatant.new()
	enemy_combatant.initialize_with_enemy_data( enemy_data )
	return enemy_combatant

func setup_audio() -> void:
	# TODO: This is testing for now. We can have the missions store what music
	# to use.
	var audio: AudioStream = preload("res://Imported Assets/Audio/Music/1-15 289 - Heated Battle (Loop) - Aron Krogh.mp3")
	SoundManager.play_music_at_volume(audio, -20.0, 0.0, "Music")
