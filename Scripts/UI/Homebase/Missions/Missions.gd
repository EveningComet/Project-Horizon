extends Control

@export_file("*.tscn") var battle_scene: String

@export var buttons_container: VBoxContainer
@export var mission_description: Label
@export var description_panel: Panel
@export var missions: Array[MissionData]

const mission_button_group_name: String = "missions"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_mision_buttons()
	description_panel.hide()

func add_mision_buttons() -> void:
	for mission in missions:
		var is_unlocked = MissionController.is_mission_unlocked( mission )
		var button = make_button( mission, is_unlocked )
		button.add_to_group( mission_button_group_name )
		buttons_container.add_child( button )

func make_button(mission: MissionData, is_unlocked: bool) -> MissionSelectButton:
	var button = MissionSelectButton.new( mission, is_unlocked )
	button.button_down.connect( on_mission_button_pressed.bind( button.mission ) )
	button.mouse_entered.connect( on_mouse_entered_mission_button.bind( button.mission ) )
	button.mouse_exited.connect( on_mouse_exited_mission_button.bind( button.mission ) )
	return button
	
func on_mission_button_pressed(mission: MissionData) -> void:
	MissionController.select_mission( mission )
	SceneController.switch_to_scene( battle_scene )
	if OS.is_debug_build() == true:
		print("Missions :: Selected mission ", MissionController.current_mission.mission_name,
			" with nr of enemies=", len( MissionController.current_mission.enemies ))
	
func on_mouse_entered_mission_button(mission: MissionData) -> void:
	mission_description.text = mission.mission_description
	description_panel.show()

func on_mouse_exited_mission_button(mission: MissionData) -> void:
	description_panel.hide()

