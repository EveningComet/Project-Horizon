extends Control

@export_file("*.tscn") var homebase_scene: String
@export_file("*.tscn") var battle_scene: String

@export var buttons_container: VBoxContainer
@export var mission_description: Label
@export var description_panel: Panel
@export var mission_select_button_template: PackedScene
@export var missions: Array[MissionData]

const mission_button_group_name: String = "missions"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_mision_buttons()
	description_panel.hide()

func _process(_delta):
	if Input.is_action_just_pressed( "ui_cancel" ):
		SceneController.switch_to_scene( homebase_scene )

func add_mision_buttons() -> void:
	for mission in missions:
		var is_unlocked = MissionController.is_mission_unlocked( mission )
		make_button( mission, is_unlocked )

func make_button(mission: MissionData, is_unlocked: bool) -> void:
	var button: MissionSelectButton = mission_select_button_template.instantiate()
	button.setup( mission, is_unlocked )
	button.button_down.connect( on_mission_button_pressed.bind( button.mission ) )
	button.mouse_entered.connect( on_mouse_entered_mission_button.bind( button.mission ) )
	button.mouse_exited.connect( on_mouse_exited_mission_button.bind( button.mission ) )
	button.add_to_group( mission_button_group_name )
	buttons_container.add_child( button )
	
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

