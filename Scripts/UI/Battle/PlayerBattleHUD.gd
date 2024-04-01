## Responsible for displaying the status of the player's characters.
class_name PlayerBattleHUD extends Control

## The prefab for the scene that is used to display the status of the player's
## characters.
@export var player_battle_ui_scene: PackedScene

## The node that will store the player's party members.
@export var player_party_container: Container

func create_hud_for_pc(new_pc: PlayerCombatant) -> void:
	var combatant_battle_ui: CombatantBattleUI = player_battle_ui_scene.instantiate()
	player_party_container.add_child( combatant_battle_ui )
	combatant_battle_ui.set_combatant( new_pc, true )
