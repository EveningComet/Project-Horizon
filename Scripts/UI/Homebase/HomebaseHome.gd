## The main screen for the homebase. This is what brings the player to other areas.
class_name HomebaseHome extends Control

@export_file("*.tscn") var battle_scene: String
@export_file("*.tscn") var recruitment_home_menu_scene: String
@export_file("*.tscn") var acquisition_menu_scene: String

@export var missions_button: BaseButton
@export var manage_characters_button: BaseButton
@export var acquisition_button: BaseButton
@export var quit_button: BaseButton

func _ready() -> void:
	# Connect the needed button events
	missions_button.button_down.connect( on_mission_button_pressed )
	manage_characters_button.button_down.connect( on_manage_characters_button_pressed )
	acquisition_button.pressed.connect( on_acquisition_button_pressed )
	quit_button.button_down.connect( on_quit_button_pressed )
	
	missions_button.disabled = !PlayerPartyController.has_members()
	
	get_first_enabled_button_or_default().grab_focus()

func on_mission_button_pressed() -> void:
	SceneController.switch_to_scene( battle_scene )

func on_manage_characters_button_pressed() -> void:
	SceneController.switch_to_scene( recruitment_home_menu_scene )

func on_acquisition_button_pressed() -> void:
	SceneController.switch_to_scene( acquisition_menu_scene )

func on_quit_button_pressed() -> void:
	# TODO: Return to the main menu.
	get_tree().quit()

func get_first_enabled_button_or_default() -> BaseButton:
	for child in find_children("*", "BaseButton", true):
		var button := child as BaseButton
		if (!button.disabled):
			return button
	return quit_button
