## Controls the menu for the multiclassing.
class_name MulticlassingMenuController extends StateMachine

## The node we're attached to.
@export var multiclassing_menu_ui_node: Control

@export var mmcpc_button_prefab: PackedScene

@export var char_class_button_prefab: PackedScene

@export var class_description_holder: Control
@export var class_description_label: Label

## Node storing the buttons.
@export var button_holder: Container

var potential_classes: Array[CharacterClass] = []

## The character that will be multiclassing.
var tracked_character: PlayerCombatant
var class_to_add: CharacterClass

func _unhandled_input(event: InputEvent) -> void:
	curr_state.check_for_unhandled_input(event)

func set_me_up() -> void:
	potential_classes.append_array( CharacterClassDb.get_database() )
	potential_classes.sort_custom( sort_name )
	super()

## Sorts the classes alphabetically.
func sort_name(a: CharacterClass, b: CharacterClass) -> bool:
	return a.localization_name < b.localization_name
