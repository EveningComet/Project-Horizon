## Middleman that handles the displayed commands.
class_name PlayerActionCommands extends Control

# Signals used to pass data for the current character.
signal attack_button_pressed
signal defend_button_pressed

# The commands that can be performed
@export var attack_button:  BaseButton
@export var special_button: BaseButton
@export var defend_button:  BaseButton
@export var run_button:     BaseButton

@export var battle_skills_menu: BattleSkillsMenu

## The combatant we want to display actions for.
var current_combatant: PlayerCombatant

func _ready() -> void:
	hide()
	attack_button.pressed.connect(  on_attack_button_pressed )
	special_button.pressed.connect( on_special_button_pressed )
	defend_button.pressed.connect(  on_defend_button_pressed )
	run_button.pressed.connect(     on_run_button_pressed    )

func open(combatant: Combatant) -> void:
	current_combatant = combatant
	# TODO: Handle saving in memory. Also, getting the child like this is dumb.
	get_child(0).get_child(0).grab_focus()
	
	show()

func close() -> void:
	current_combatant = null
	hide()
	close_battle_skills_menu()

func on_attack_button_pressed() -> void:
	if OS.is_debug_build() == true:
		print("PlayerActionCommands :: Attack button pressed.")
	
	attack_button_pressed.emit()

func on_special_button_pressed() -> void:
	open_battle_skills_menu()

func on_defend_button_pressed() -> void:
	defend_button_pressed.emit()

func on_run_button_pressed() -> void:
	# TODO: Testing. Make sure this does the proper thing.
	get_tree().quit()

func open_battle_skills_menu() -> void:
	# Make the battle skills menu display the usable skills to the player
	battle_skills_menu.open( current_combatant )
	hide()

func close_battle_skills_menu() -> void:
	battle_skills_menu.close()
