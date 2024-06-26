## The main screen for the homebase. This is what brings the player to other areas.
class_name HomebaseHome extends Control

@export_file("*.tscn") var missions_scene: String
@export_file("*.tscn") var recruitment_home_menu_scene: String
@export_file("*.tscn") var acquisition_menu_scene: String

@export var buttons_container: Container
@export var party_dashboard: PartyDashboard

@export var missions_button: BaseButton
@export var manage_characters_button: BaseButton
@export var acquisition_button: BaseButton
@export var quit_button: BaseButton

@export var skill_menu: CanvasLayer

## The background music that will play upon entering this menu.
@export var background_music: AudioStream

var previous_focus: Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_skills"):
		skill_menu.visible = !skill_menu.visible
		
		# Store and get the previously focused node depending on what happens
		# TODO: Fix the error that occurs here when opening/closing these menus.
		if skill_menu.visible == true:
			previous_focus = get_viewport().gui_get_focus_owner()
			buttons_container.hide()
		else:
			previous_focus.grab_focus()
			buttons_container.show()
	
	elif event.is_action_pressed("toggle_inventory"):
		if party_dashboard.visible == true:
			previous_focus = get_viewport().gui_get_focus_owner()
			buttons_container.hide()
		else:
			previous_focus.grab_focus()
			buttons_container.show()

func _ready() -> void:
	# Play the background music for this menu
	SoundManager.play_music(background_music, 0.0, "Music")
	
	# Connect the needed button events
	missions_button.button_down.connect( on_mission_button_pressed )
	manage_characters_button.button_down.connect( on_manage_characters_button_pressed )
	acquisition_button.pressed.connect( on_acquisition_button_pressed )
	quit_button.button_down.connect( on_quit_button_pressed )
	
	# Do not let the player start a mission without characters or 0 hp characters
	missions_button.disabled = !PlayerPartyController.has_members()
	missions_button.disabled = !PlayerPartyController.is_party_fightable()
	
	get_first_enabled_button_or_default().grab_focus()
	skill_menu.hide()

func on_mission_button_pressed() -> void:
	SceneController.switch_to_scene( missions_scene )

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
