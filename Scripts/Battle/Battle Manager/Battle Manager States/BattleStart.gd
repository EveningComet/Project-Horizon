## Entered when a battle starts.
class_name BattleStart extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	setup_battle()
	
	if OS.is_debug_build() == true:
		print("BattleStart :: Entered.")

func physics_update(delta: float) -> void:
	# TODO: This should really happen in an event after everything is finished being setup.
	my_state_machine.change_to_state("PlayerTurn")

func setup_battle() -> void:
	# Refresh the death handler
	my_state_machine.death_handler.refresh()
	
	# Spawn the necessary characters.
	spawn_player_characters()
	spawn_enemies()
	
	# TODO: Connect to any relevant events.

func spawn_player_characters() -> void:
	# Create copies of the player's characters and add them to this scene.
	var player_party = PlayerPartyController.get_children()
	for player_character: PlayerCombatant in player_party:
		var copy: PlayerCombatant = PlayerCombatant.new()
		copy.initialize_with_copy( player_character ) # Initialize the stats for safety.
		my_state_machine.spawned_combatants_node.add_child( copy )
		my_state_machine.player_battle_hud.create_hud_for_pc( copy )
		copy.name = player_character.char_name
		
		# Connect to on hp depleted events.
		copy.health_depleted.connect( my_state_machine.death_handler.on_player_character_death )
		
		# Make the state machine keep track of the character
		my_state_machine.add_combatant( copy )

func spawn_enemies() -> void:
	# TODO: Spawn the enemies, add them to the scene, and add them to the tracked combatants list.
	for character in my_state_machine.spawned_combatants_node.get_children():
		if character is EnemyCombatant:
			my_state_machine.add_combatant( character )
			character.health_depleted.connect( my_state_machine.death_handler.on_enemy_death )
