## Entered when a battle starts.
class_name BattleStart extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	setup_battle()
	
	if OS.is_debug_build() == true:
		print("BattleStart :: Entered.")

func setup_battle() -> void:
	# Refresh the death handler
	my_state_machine.death_handler.refresh()
	
	EventBus.combatant_spawned_in_battle.connect( my_state_machine.player_battle_hud.on_combatant_spawned_in_combat )
	EventBus.combatant_spawned_in_battle.connect( my_state_machine.enemy_battle_hud.on_combatant_spawned_in_combat )
	
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
		
		# Make the state machine keep track of the character
		my_state_machine.add_combatant( player_character )
		
		# Fire the event to create UI for the character
		EventBus.combatant_spawned_in_battle.emit( player_character )

func spawn_enemies() -> void:
	# TODO: Spawn the enemies, add them to the scene, and add them to the tracked combatants list.
	for character in my_state_machine.spawned_combatants_node.get_children():
		if character is EnemyCombatant:
			my_state_machine.add_combatant( character )
			EventBus.combatant_spawned_in_battle.emit( character )
