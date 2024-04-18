class_name AttributesMenu extends Node

@export var points_label: Label
@export var confirm_button: Button
@export var container: VBoxContainer
@export var menu_entry_template: PackedScene

signal attribute_points_depleted
signal attribute_points_available

var character: PlayerCombatant
var draft_points: int = 0

var character_changed: Signal
const attributes_group_name := "attributes"

func initialize(_character_changed: Signal):
	character_changed = _character_changed
	character_changed.connect( update_and_render )
	confirm_button.button_down.connect( confirm )
	spawn_entries_for_attributes()
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	set_draft_points( character.available_attribute_points )

func confirm():
	character.available_attribute_points = draft_points
	set_draft_points( character.available_attribute_points )
	get_tree().call_group( attributes_group_name, "confirm" )

func attribute_upgraded():
	set_draft_points( draft_points - 1 )

func attribute_downgraded():
	set_draft_points( draft_points + 1 )

func set_draft_points(points: int):
	draft_points = points
	emit_correct_signal()
	update_points_label()
	disable_confirm_if_no_action_taken()

func emit_correct_signal():
	if (draft_points == 0):
		emit_signal( "attribute_points_depleted" )
	elif (draft_points > 0):
		emit_signal( "attribute_points_available" )

func update_points_label():
	points_label.text = "Available attribute points: "
	points_label.text += str( draft_points )

func disable_confirm_if_no_action_taken():
	var action_taken := draft_points != character.available_attribute_points
	confirm_button.disabled = not action_taken

func spawn_entries_for_attributes():
	for attribute in StatTypes.new().attributes():
		var entry := menu_entry_template.instantiate() as AttributeMenuEntry
		entry.initialize(
			attribute, character_changed, attribute_points_depleted, attribute_points_available )
		entry.attribute_upgraded.connect( attribute_upgraded )
		entry.attribute_downgraded.connect( attribute_downgraded )
		entry.add_to_group( attributes_group_name )
		container.add_child( entry )