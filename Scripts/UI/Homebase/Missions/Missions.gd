extends Control

@export var level_label : Label
@export var container : VBoxContainer
@export var prev_level_button : BaseButton
@export var next_level_button : BaseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	set_level_label(MissionController.get_current_level())
	prev_level_button.disabled = !MissionController.has_prev_level()
	next_level_button.disabled = !MissionController.has_next_level()
	
	for encounter in MissionController.get_available_encounters():
		container.add_child(make_button(encounter.enemy.name))
		
	MissionController.level_changed.connect( set_level_label )
	
	#TODO: Test code for seeing that next level is rendered correctly, remove
	next_level_button.button_down.connect( MissionController.level_up )

func set_level_label(level: int) -> void:
	level_label.text = "Level: " + str(level)

func make_button(text: String) -> BaseButton:
	var button = Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(200, 50)
	return button
	
