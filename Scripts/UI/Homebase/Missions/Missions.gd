extends Control

@export_file("*.tscn") var battle_scene: String

@export var level_label: Label
@export var container: VBoxContainer
@export var prev_level_button: BaseButton
@export var next_level_button: BaseButton
@export var minimum_button_size: Vector2 = Vector2(200, 50)

const mission_button_group_name: String = "missions"

# Called when the node enters the scene tree for the first time.
func _ready():
	render_level(MissionController.get_current_level())
	MissionController.level_changed.connect( render_level )
	next_level_button.button_down.connect( MissionController.level_up )
	prev_level_button.button_down.connect( MissionController.level_down )

func render_level(level: int) -> void:
	set_level_label(level)
	update_next_and_prev_button()
	remove_all_mission_buttons()
	add_mision_buttons()

func set_level_label(level: int) -> void:
	level_label.text = "Level: " + str(level)

func update_next_and_prev_button() -> void:
	prev_level_button.disabled = !MissionController.has_prev_level()
	next_level_button.disabled = !MissionController.has_next_level()

func add_mision_buttons() -> void:
	for encounter in MissionController.get_available_missions():
		var button = make_button(encounter.enemy.name)
		button.add_to_group(mission_button_group_name)
		container.add_child(button)

func make_button(text: String) -> BaseButton:
	var button = Button.new()
	button.text = text
	button.custom_minimum_size = minimum_button_size
	button.button_down.connect( on_mission_button_pressed )
	return button
	
func on_mission_button_pressed() -> void:
	SceneController.switch_to_scene( battle_scene )

func remove_all_mission_buttons() -> void:
	for button in get_tree().get_nodes_in_group(mission_button_group_name):
		container.remove_child(button)
		button.queue_free()
	
