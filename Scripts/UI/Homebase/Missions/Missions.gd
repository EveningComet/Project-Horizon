extends Control

@export_file("*.tscn") var battle_scene: String

@export var unlocked_label: Label
@export var container: VBoxContainer
@export var missions: Array[MissionData]

const mission_button_group_name: String = "missions"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_unlocked_label()
	add_mision_buttons()

func set_unlocked_label() -> void:
	unlocked_label.text = "Unlocked: "
	unlocked_label.text += str( MissionController.number_of_missions_completed() )
	unlocked_label.text += "/" + str( len(missions) )

func add_mision_buttons() -> void:
	for mission in missions:
		var is_unlocked = MissionController.is_mission_unlocked( mission )
		var button = make_button( mission, is_unlocked )
		button.add_to_group( mission_button_group_name )
		container.add_child( button )

func make_button(mission: MissionData, is_unlocked: bool) -> MissionSelectButton:
	var button = MissionSelectButton.new( mission, is_unlocked )
	button.button_down.connect( on_mission_button_pressed.bind( button.mission ) )
	return button
	
func on_mission_button_pressed(mission: MissionData) -> void:
	MissionController.select_mission( mission )
	SceneController.switch_to_scene( battle_scene )
	if OS.is_debug_build() == true:
		print("Missions :: Selected mission ", MissionController.current_mission.mission_name,
			" with nr of enemies=", len( MissionController.current_mission.enemies ))
