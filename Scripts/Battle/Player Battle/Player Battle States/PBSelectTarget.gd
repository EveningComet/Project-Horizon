## State for when the player is selecting a potential_target for an action.
class_name PBSelectTarget extends PlayerBattleState

@export var battle_cursor_controller: BattleCursorController

# The huds which will help with getting targets
@export var enemy_battle_hud:  EnemyBattleHUD
@export var player_battle_hud: PlayerBattleHUD

## The action for the current character that will possibly be passed along.
var stored_action: StoredAction

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{"stored_action": var sa}:
			if OS.is_debug_build() == true:
				print("PBSelectTarget :: Entered with action. Action type is %s" % [ActionTypes.ActionTypes.keys()[sa.action_type]])
			
			stored_action = sa
			
			## Depending on the action type, just move on
			match stored_action.action_type:
				ActionTypes.ActionTypes.Defend, ActionTypes.ActionTypes.Flee:
					execute()
					return
			
			# Create the needed cursors
			battle_cursor_controller.spawn_needed_cursors( stored_action )
	
	# Connection for the mouse control
	for child: Control in enemy_battle_hud.enemy_party_container.get_children():
		child.mouse_entered.connect( on_mouse_over )

func exit() -> void:
	stored_action = null
	
	# Delete all spawned battle cursors
	battle_cursor_controller.clear_cursors()
	
	for child: Control in enemy_battle_hud.enemy_party_container.get_children():
		child.mouse_entered.disconnect( on_mouse_over )
	
func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		my_state_machine.change_to_state("PBSelectAction")
		return
	
	# TODO: Acceptable mouse input.
	if event.is_action_pressed("ui_accept"):
		execute()
		return
	
	# Check for keyboard/gamepad input to move the cursor
	var input_dir: Vector2 = Vector2.ZERO
	if event.is_action_pressed("ui_up"):
		input_dir = Vector2.UP
	if event.is_action_pressed("ui_right"):
		input_dir = Vector2.RIGHT
	if event.is_action_pressed("ui_down"):
		input_dir = Vector2.DOWN
	if event.is_action_pressed("ui_left"):
		input_dir = Vector2.LEFT
	
	if input_dir != Vector2.ZERO:
		battle_cursor_controller.find_closest_target( input_dir )

func on_mouse_over() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	#var potential_target = find_closest_target( mouse_pos )
	#if potential_target != null:
		#select_targets( potential_target )

func execute() -> void:
	stored_action.set_targets( battle_cursor_controller.get_targets() )
	store_action(my_state_machine.get_current_combatant(), stored_action)
	
	# Move to the desired state, based on whether or not the player
	# selected an action for all the characters
	if my_state_machine.has_finished_selecting_needed_actions() == true:
		if OS.is_debug_build() == true:
			printerr("PBSelectTarget :: The player has finally finished selecting all the actions! Time for the enemy's turn.")
			printerr("PBSelectTarget :: Action dictionary is: ", my_state_machine.stored_actions)
		
		
		# Clean up for the end of the turn
		var actions_to_send: Array[StoredAction] = my_state_machine.clean_up_for_turn_end_and_return_stored_actions_as_list()
		
		# Tell the battle controller that it's now the enemy's turn
		EventBus.side_finished_turn.emit( actions_to_send )
		my_state_machine.change_to_state("PBIdle")
	
	# The player still has characters to select actions for
	else:
		if OS.is_debug_build() == true:
			print("PBSelectTarget :: Action dictionary is: ", my_state_machine.stored_actions)
		
		my_state_machine.advance_to_next_character()
		my_state_machine.change_to_state("PBSelectAction")

## Have the state machine cache the action that was selected for the character.
func store_action(combatant_to_store: Combatant, action_to_store: StoredAction) -> void:
	my_state_machine.store_action(
		combatant_to_store,
		action_to_store
	)
