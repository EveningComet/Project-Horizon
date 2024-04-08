## Responsible for the entirety of the recruitment menu.
class_name RecruitmentMenuController extends Node

## The scene storing the "main menu" for the homebase.
@export_file("*.tscn") var homebase_main_menu_scene: String

@export var character_class_button_template: PackedScene

## The holder of the buttons of the recruitment's "main menu."
@export var main_screen_button_holder: Control

## The menu where the player can manage their party.
@export var party_management_menu: PartyManagementMenu

## The screen that will display the classes the player can recruit from.
@export var recruitable_menu: RecruitableMenu

@export var recruitment_button: BaseButton = null

## The management button.
@export var management_button: BaseButton

## The button for returning to the "main menu" of the homebase.
@export var return_button: BaseButton = null

# TODO: Figure out how to load the classes through the folder instead of loading manually.
@export var pc_classes: Array[CharacterClass] = []

func _ready() -> void:
	# Set the focus for the needed button
	main_screen_button_holder.get_child(0).grab_focus()
	
	# Connect to relevant events
	recruitable_menu.close_recruitable_menu.connect( on_close_recruitable_menu )
	party_management_menu.close_party_management_menu.connect( on_close_party_management_menu )
	
	# Connect to the buttons
	recruitment_button.button_down.connect( on_recruitment_button_pressed )
	management_button.pressed.connect( on_manage_button_pressed )
	return_button.button_down.connect( on_return_button_pressed )
	
	# Load the character classes and sort them
	load_classes()

## Loads the data for character classes.
func load_classes() -> void:
	# First, make sure the classes are in alphabetical order
	pc_classes.sort_custom( sort_name )

## Event fired when the player is requesting to close the recruitable menu.
func on_close_recruitable_menu() -> void:
	recruitable_menu.close()
	main_screen_button_holder.show()
	main_screen_button_holder.get_child(0).grab_focus()

func on_close_party_management_menu() -> void:
	party_management_menu.close()
	main_screen_button_holder.show()
	main_screen_button_holder.get_child(0).grab_focus()

func on_recruitment_button_pressed() -> void:
	main_screen_button_holder.hide()
	recruitable_menu.display_classes( pc_classes )

func on_manage_button_pressed() -> void:
	# TODO: Do this a proper way. This is for now.
	if PlayerPartyController.get_child_count() < 1:
		return
	main_screen_button_holder.hide()
	party_management_menu.display()

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_main_menu_scene )

func sort_name(a: CharacterClass, b: CharacterClass) -> bool:
	return a.localization_name < b.localization_name
