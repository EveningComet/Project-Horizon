## Controls the scene for buying items and equipment.
class_name AcquisitionMenuController extends Node

@export_file("*.tscn") var homebase_menu_scene: String

@export var return_button: BaseButton

func _ready() -> void:
	return_button.pressed.connect( on_return_button_pressed )

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_menu_scene )
