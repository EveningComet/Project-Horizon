## State machine responsible for handling battles.
class_name BattleManager extends StateMachine

## The handler for keeping track of characters dying/falling in battle.
@export var death_handler: BattleDeathHandler

## The object responsible for displaying the status of the player's characters.
@export var player_battle_hud: PlayerBattleHUD

## Responsible for displaying enemies to the player.
@export var enemy_battle_hud: EnemyBattleHUD

## Houses the spawned characters.
@export var spawned_combatants_node: Node

## The group name of nodes that are EnemyCombatant
const ENEMY_GROUP_NAME := "EnemyCombatants"

## The group name of nodes that are PlayerCombatant
const PLAYER_GROUP_NAME := "PlayerCombatants"

## The current actions that will be executed.
var current_turn_actions: Array[StoredAction] = []

## The characters currently participating in battle.
var combatants: Array[Combatant] = []

## The current turn we're on in this battle.
var current_turn: int = 0

func set_me_up() -> void:
	EventBus.hp_depleted.connect( on_hp_depleted )
	super()

func complete_player_turn(actions_to_store: Array[StoredAction]) -> void:
	current_turn_actions.append_array( actions_to_store )

func add_combatant(new_combatant: Combatant) -> void:
	combatants.append( new_combatant )

func remove_combatant(combatant_to_remove: Combatant) -> void:
	if combatants.has( combatant_to_remove ) == true:
		combatants.erase( combatant_to_remove )

func on_hp_depleted(combatant: Combatant) -> void:
	if combatants.has(combatant):
		combatants.erase( combatant )
