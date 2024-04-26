## Responsible for the entirety of the recruitment menu.
class_name RecruitmentMenuController extends Node

## The scene storing the "main menu" for the homebase.
@export_file("*.tscn") var homebase_main_menu_scene: String

@export var character_class_button_template: PackedScene

## The holder of the buttons of the recruitment's "main menu."
@export var main_screen_button_holder: Control

## The menu where the player can manage their party.
@export var party_management_menu: PartyManagementMenu

## The menu for recruiting new characters.
@export var recruitable_menu: Control

## The menu where the player will handle multiclassing party members.
@export var multiclassing_menu: Control

## The button that will open the recruitable menu.
@export var recruitment_button: Button = null

## The button that will take the player to the menu where they will manage
## set what characters are in their party.
@export var manage_party_button: Button

## The button that will take the player to the menu for managing the multiclass.
@export var set_multiclass_button: Button

## The button for returning to the "main menu" of the homebase.
@export var return_button: Button = null

func _ready() -> void:
	# Set the focus for the needed button
	main_screen_button_holder.get_child(0).grab_focus()
	
	# Connect to relevant events
	main_screen_button_holder.visibility_changed.connect(
		on_main_screen_visibility_changed
	)
	on_main_screen_visibility_changed()
	recruitable_menu.visibility_changed.connect(
		on_recruitable_menu_visibility_changed
	)
	party_management_menu.close_party_management_menu.connect(
		on_close_party_management_menu
	)
	multiclassing_menu.visibility_changed.connect(
		on_multiclassing_menu_visibility_changed
	)
	
	# Connect to the buttons
	recruitment_button.button_down.connect( on_recruitment_button_pressed )
	manage_party_button.button_down.connect( on_manage_party_button_pressed )
	set_multiclass_button.button_down.connect( on_set_multiclass_button_pressed )
	return_button.button_down.connect( on_return_button_pressed )

func on_close_party_management_menu() -> void:
	party_management_menu.close()
	main_screen_button_holder.show()
	main_screen_button_holder.get_child(0).grab_focus()

func on_recruitable_menu_visibility_changed() -> void:
	if recruitable_menu.visible == false:
		main_screen_button_holder.show()
		main_screen_button_holder.get_child(0).grab_focus()

func on_multiclassing_menu_visibility_changed() -> void:
	if multiclassing_menu.visible == false:
		main_screen_button_holder.show()
		main_screen_button_holder.get_child(0).grab_focus()

func on_main_screen_visibility_changed() -> void:
	if main_screen_button_holder.visible == true:
		if PlayerPartyController.has_members() == false:
			manage_party_button.disabled = true
			set_multiclass_button.disabled = true
		else:
			manage_party_button.disabled   = false
			set_multiclass_button.disabled = false

func on_recruitment_button_pressed() -> void:
	main_screen_button_holder.hide()
	recruitable_menu.show()

func on_manage_party_button_pressed() -> void:
	main_screen_button_holder.hide()
	party_management_menu.display()

func on_set_multiclass_button_pressed() -> void:
	main_screen_button_holder.hide()
	multiclassing_menu.show()

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_main_menu_scene )
