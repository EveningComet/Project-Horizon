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
@export var recruitable_menu: Control

## The button that will open the recruitable menu.
@export var recruitment_button: BaseButton = null

## The management button.
@export var manage_party_button: BaseButton

## The button for returning to the "main menu" of the homebase.
@export var return_button: BaseButton = null

func _ready() -> void:
	# Set the focus for the needed button
	main_screen_button_holder.get_child(0).grab_focus()
	
	# Connect to relevant events
	recruitable_menu.visibility_changed.connect(
		on_recruitable_menu_visibility_changed
	)
	party_management_menu.close_party_management_menu.connect( on_close_party_management_menu )
	
	# Connect to the buttons
	recruitment_button.button_down.connect( on_recruitment_button_pressed )
	manage_party_button.button_down.connect( on_manage_party_button_pressed )
	return_button.button_down.connect( on_return_button_pressed )

func on_close_party_management_menu() -> void:
	party_management_menu.close()
	main_screen_button_holder.show()
	main_screen_button_holder.get_child(0).grab_focus()

func on_recruitable_menu_visibility_changed() -> void:
	if recruitable_menu.visible == false:
		main_screen_button_holder.show()
		main_screen_button_holder.get_child(0).grab_focus()

func on_recruitment_button_pressed() -> void:
	main_screen_button_holder.hide()
	recruitable_menu.show()

func on_manage_party_button_pressed() -> void:
	# TODO: Do this a proper way. This is fine for now.
	if PlayerPartyController.get_child_count() < 1:
		return
	main_screen_button_holder.hide()
	party_management_menu.display()

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_main_menu_scene )
