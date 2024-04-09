## Responsible for managing cursors in a battle.
class_name BattleCursorController extends Node

## Prefab of the cursor scene.
@export var battle_cursor_scene: PackedScene

## Canvas layer that will house the spawned cursors.
@export var canvas_layer: CanvasLayer

# UI that houses the inbetween for visuals and their data
@export var enemy_battle_ui:  GridContainer
@export var player_battle_ui: GridContainer

## Cursors being tracked.
var spawned_cursors: Array = []

## The characters that are the current targets.
var targets: Array[Combatant] = []

## Spawns the needed cursors based on the passed action.
func spawn_needed_cursors(new_action: StoredAction) -> void:
	match new_action.action_type:
		ActionTypes.ActionTypes.SingleEnemy:
			var cursor = battle_cursor_scene.instantiate()
			spawned_cursors.append( cursor )
			canvas_layer.add_child( cursor )
			
			# Set the target to the first enemy
			# TODO: More robust system for remembering the previously selected target?
			set_single_target( enemy_battle_ui.get_child(0) )
		
		ActionTypes.ActionTypes.HealSingleAlly:
			pass
			

func clear_cursors() -> void:
	for cursor in spawned_cursors:
		cursor.queue_free()
	spawned_cursors.clear()
	targets.clear()

## Find the closest target for a cursor. This method should only do stuff when
## there is one cursor.
func find_closest_target(direction: Vector2) -> void:
	var selected_target        = null
	var target_distance: float = INF
	var curr_pos: Vector2 = spawned_cursors[0].global_position
	for battler in enemy_battle_ui.get_children():
		var dist = curr_pos.distance_to(battler.global_position)
		if dist < target_distance:
			selected_target = battler
			target_distance = dist
	
	if selected_target != null:
		# Set the cursor's position
		set_single_target( selected_target )

func set_single_target(new_target: CombatantBattleUI) -> void:
	targets.clear()
	var com: Combatant = new_target.get_combatant()
	targets.append( com )
	spawned_cursors[0].global_position = new_target.global_position + Vector2(5, 5)

## Accessor for getting the targets.
func get_targets() -> Array[Combatant]:
	return targets
