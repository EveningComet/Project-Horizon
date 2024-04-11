## Displays the results of a battle to the player.
class_name BattleResultsScreen extends Control

@export var pm_result_prefab: PackedScene

@export var party_grid_container: GridContainer

@export_file("*.tscn") var homebase_scene: String

var is_active = false

func _unhandled_input(event: InputEvent) -> void:
	if is_active == true and event.is_pressed():
		is_active = false
		hide()
		SceneController.switch_to_scene( homebase_scene )
		return

func _ready() -> void:
	is_active = false
	hide()

func activate(xp_to_reward: int) -> void:
	show()
	handle_player_victory(xp_to_reward)

func handle_player_victory(xp_to_reward: int) -> void:
	# Spawn a portrait of everyone that fought in this battle
	for pm: PlayerCombatant in PlayerPartyController.party_members:
		var pm_battle_result: PMBattleResult = pm_result_prefab.instantiate()
		party_grid_container.add_child( pm_battle_result )
		pm_battle_result.set_player_character( pm )
	
	# Give the experience points
	for pm: PlayerCombatant in PlayerPartyController.party_members:
		pm.gain_experience( xp_to_reward )
	
	# Populate the item menu, if relevant
	
	# Prevent the player from dipping before seeing anything
	await get_tree().create_timer(0.5).timeout 
	is_active = true

# TODO: Implement defeat and retreat.
func handle_player_defeat() -> void:
	pass

func player_retreat() -> void:
	pass
