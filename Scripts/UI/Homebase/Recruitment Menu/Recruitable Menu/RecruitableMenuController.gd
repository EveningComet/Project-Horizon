## Manages the recruitable menu.
class_name RecruitableMenuController extends StateMachine

## The major node storing the recruitable menu.
@export var recruitable_menu_node: Control

## The node that will house the character classes to display
@export var class_container: Container

## The master parent of the class description.
@export var class_description_holder: Control

## Displays the description of classes.
@export var class_description_label: Label

## Template for creating the character class buttons.
@export var character_class_button_template: PackedScene

## Container that will house the displayed portraits.
@export var portraits_container: Container

@export var portrait_displayer_template: PackedScene

## Stores a local copy of the character classes.
var character_classes: Array[CharacterClass] = []

var created_character: PlayerCombatant = null
var starting_class:    CharacterClass  = null

func set_me_up() -> void:
	load_classes()
	character_classes.sort_custom( sort_name )
	super()

func _unhandled_input(event: InputEvent) -> void:
	curr_state.check_for_unhandled_input( event )

## Load the needed character classes.
func load_classes() -> void:
	character_classes.clear()
	character_classes.append_array( CharacterClassDb.get_database() )

## Sorts the classes alphabetically.
func sort_name(a: CharacterClass, b: CharacterClass) -> bool:
	return a.localization_name < b.localization_name

func get_all_portraits() -> Array[PortraitData]:
	var all_portraits: Array[PortraitData]
	for cc in character_classes:
		all_portraits.append_array(cc.get_portraits())
	return all_portraits
