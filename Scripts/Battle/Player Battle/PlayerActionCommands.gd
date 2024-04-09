## Middleman that handles the displayed commands.
class_name PlayerActionCommands extends Control

signal action_selected(stored_action: StoredAction)

## The button used to activate skills.
@export var special_button: BaseButton

@export var battle_skills_menu: BattleSkillsMenu

## The combatant we want to display actions for.
var current_combatant: PlayerCombatant

## The action that will be passed along for the player.
var stored_action: StoredAction

func _ready() -> void:
	hide()
	special_button.pressed.connect( on_special_button_pressed )
	
	# Subscribe to any needed events from the regular buttons
	for button in get_child(0).get_children():
		if button is BattleActionButton:
			# TODO: Depending on the equipped weapon, a character may be able to attack all enemies at once.
			# So maybe the attack button should have a use weapon tag or something.
			button.action_button_pressed.connect( on_action_button_pressed )

func open(combatant: Combatant) -> void:
	current_combatant = combatant
	stored_action = StoredAction.new()
	stored_action.activator = current_combatant
	special_button.disabled = current_combatant.available_skills.size() < 1
	
	if special_button.disabled == false:
		battle_skills_menu.set_skill_user( current_combatant )
		for button in battle_skills_menu.spawned_button_node.get_children():
			button.action_button_pressed.connect( on_action_button_pressed )
	
	# TODO: Handle saving in memory. Also, getting the child like this is dumb.
	get_child(0).get_child(0).grab_focus()
	show()

func close() -> void:
	current_combatant = null
	hide()
	for button: BattleActionButton in battle_skills_menu.spawned_button_node.get_children():
		button.action_button_pressed.disconnect( on_action_button_pressed )
	close_battle_skills_menu()
	
func on_action_button_pressed(action_button: BattleActionButton) -> void:
	stored_action.action_type = action_button.action_type
	stored_action.skill_data  = action_button.skill
	action_selected.emit( stored_action )
	
func on_special_button_pressed() -> void:
	open_battle_skills_menu()

func open_battle_skills_menu() -> void:
	# Make the battle skills menu display the usable skills to the player
	battle_skills_menu.open()
	hide()

func close_battle_skills_menu() -> void:
	battle_skills_menu.close()
