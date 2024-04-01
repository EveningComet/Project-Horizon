## The main screen for the homebase. This is what brings the player to other areas.
class_name HomebaseHome extends Control

@export_file("*.tscn") var battle_scene: String
@export_file("*.tscn") var recruitment_home_menu_scene: String

@export var missions_button: BaseButton
@export var manage_characters_button: BaseButton
@export var quit_button: BaseButton

func _ready() -> void:
	# TODO: Get focus more elegantly.
	get_child(0).get_child(0).grab_focus()
	
	# Connect the needed button events
	missions_button.button_down.connect( on_mission_button_pressed )
	manage_characters_button.button_down.connect( on_manage_characters_button_pressed )
	quit_button.button_down.connect( on_quit_button_pressed )

func on_mission_button_pressed() -> void:
	# TODO: Implement a better way of preventing the player from entering the battle scene.
	if PlayerPartyController.get_child_count() < 1:
		return
	SceneController.switch_to_scene( battle_scene )

func on_manage_characters_button_pressed() -> void:
	SceneController.switch_to_scene( recruitment_home_menu_scene )

func on_quit_button_pressed() -> void:
	# TODO: Return to the main menu.
	get_tree().quit()
