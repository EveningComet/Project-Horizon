## Responsible for managing cursors in a battle.
class_name BattleCursorController extends Node

## Prefab of the cursor scene.
@export var battle_cursor_scene: PackedScene

## Canvas layer that will house the spawned cursors.
@export var canvas_layer: CanvasLayer

# UI that houses the inbetween for visuals and their data
@export var enemy_battle_ui:  EnemyBattleHUD
@export var player_battle_ui: PlayerBattleHUD
var target_scan_node: Control

## Cursors being tracked.
var spawned_cursors: Array = []

## The characters that are the current targets.
var targets: Array[Combatant] = []

## Used for single target actions.
var curr_index: int = 0

## Spawns the needed cursors based on the passed action.
func spawn_needed_cursors(new_action: StoredAction) -> void:
	match new_action.action_type:
		ActionTypes.ActionTypes.SingleEnemy:
			var cursor = battle_cursor_scene.instantiate()
			spawned_cursors.append( cursor )
			canvas_layer.add_child( cursor )
			
			# Set the target to the first enemy
			# TODO: More robust system for remembering the previously selected target.
			set_target_for_cursor(cursor, enemy_battle_ui.enemy_party_container.get_child(0), true )
			target_scan_node = enemy_battle_ui.enemy_party_container
		
		ActionTypes.ActionTypes.AllEnemies:
			for enemy_ui: CombatantBattleUI in enemy_battle_ui.enemy_party_container.get_children():
				var cursor = battle_cursor_scene.instantiate()
				spawned_cursors.append( cursor )
				canvas_layer.add_child( cursor )
				
				set_target_for_cursor( cursor, enemy_ui, false )
		
		ActionTypes.ActionTypes.SingleAlly:
			var cursor = battle_cursor_scene.instantiate()
			spawned_cursors.append( cursor )
			canvas_layer.add_child( cursor )
			
			# Set the target to be the first ally
			# TODO: Caching the previous target for convenience.
			set_target_for_cursor(cursor, player_battle_ui.player_party_container.get_child(0), true )
			target_scan_node = player_battle_ui.player_party_container
		
		ActionTypes.ActionTypes.AllAllies:
			for ally_ui: CombatantBattleUI in player_battle_ui.player_party_container.get_children():
				var cursor = battle_cursor_scene.instantiate()
				spawned_cursors.append( cursor )
				canvas_layer.add_child( cursor )
				
				set_target_for_cursor( cursor, ally_ui, false )

func clear_cursors() -> void:
	for cursor in spawned_cursors:
		cursor.queue_free()
	spawned_cursors.clear()
	targets.clear()
	curr_index = 0

func set_target_for_cursor(cursor, battler_ui: CombatantBattleUI, overrides: bool) -> void:
	if overrides == true:
		targets.clear()
	
	var new_target: Combatant = battler_ui.get_combatant()
	targets.append( new_target )
	cursor.global_position = battler_ui.global_position + Vector2(5, 5)

func find_closest_target_to_mouse(mouse_pos: Vector2) -> void:
	var potential_target: CombatantBattleUI = null
	var target_dist: float = INF
	for battler: CombatantBattleUI in target_scan_node.get_children():
		var dist = mouse_pos.distance_to(battler.global_position)
		if dist < target_dist:
			potential_target = battler
			target_dist      = dist
	if targets.has(potential_target.get_combatant()) == true:
		return
	set_target_for_cursor( spawned_cursors[0], potential_target, true )

## Find the closest target for a cursor. This method should only do stuff when
## there is one cursor.
func find_closest_target(direction: Vector2) -> void:
	# It's safe to assume that the player is doing something that targets a lot
	if spawned_cursors.size() > 1:
		return
	
	if direction.x > 0 or direction.y > 0:
		curr_index += 1
	elif direction.x < 0 or direction.y < 0:
		curr_index -= 1
	
	if curr_index > target_scan_node.get_child_count() - 1:
		curr_index = 0
	elif curr_index < 0:
		curr_index = target_scan_node.get_child_count() - 1
	
	var selected_target: CombatantBattleUI = target_scan_node.get_child( curr_index )
	if targets.has(selected_target.get_combatant()) == true:
		return
	
	set_target_for_cursor( spawned_cursors[0], selected_target, true)

## Accessor for getting the targets.
func get_targets() -> Array[Combatant]:
	return targets
