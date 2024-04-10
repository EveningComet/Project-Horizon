## Responsible for displaying enemies to the player.
class_name EnemyBattleHUD extends Control

@export var enemy_battle_ui_prefab: PackedScene

@export var enemy_party_container: Container

func on_combatant_spawned_in_combat(combatant: Combatant) -> void:
	if combatant is EnemyCombatant:
		if OS.is_debug_build() == true:
			print("EnemyBattleHud :: Spawning for an enemy.")
		var ec: EnemyCombatant = combatant as EnemyCombatant
		create_hud_for_ec( ec )

func create_hud_for_ec(new_ec: EnemyCombatant) -> void:
	var combatant_battle_ui: CombatantBattleUI = enemy_battle_ui_prefab.instantiate()
	enemy_party_container.add_child( combatant_battle_ui )
	combatant_battle_ui.set_combatant( new_ec, false )
