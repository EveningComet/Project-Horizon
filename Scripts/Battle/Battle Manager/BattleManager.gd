## State machine responsible for handling battles.
class_name BattleManager extends StateMachine

signal player_turn_started

## The handler for keeping track of characters dying/falling in battle.
@export var death_handler: BattleDeathHandler

## The object responsible for displaying the status of the player's characters.
@export var player_battle_hud: PlayerBattleHUD

## Responsible for displaying enemies to the player.
@export var enemy_battle_hud: EnemyBattleHUD

## Houses the spawned characters.
@export var spawned_combatants_node: Node

## The current actions that will be executed.
var current_turn_actions: Array[StoredAction] = []

## The characters currently participating in battle.
var combatants: Array[Combatant] = []

## The current turn we're on in this battle.
var current_turn: int = 0

func _physics_process(delta: float) -> void:
	curr_state.physics_update( delta )

func begin_player_turn() -> void:
	current_turn_actions.clear()
	current_turn += 1
	player_turn_started.emit()

func complete_player_turn(actions_to_store: Array[StoredAction]) -> void:
	current_turn_actions.append_array( actions_to_store )
	change_to_state("EnemyTurn")

func add_combatant(new_combatant: Combatant) -> void:
	combatants.append( new_combatant )

func remove_combatant(combatant_to_remove: Combatant) -> void:
	if combatants.has( combatant_to_remove ) == true:
		combatants.erase( combatant_to_remove )
