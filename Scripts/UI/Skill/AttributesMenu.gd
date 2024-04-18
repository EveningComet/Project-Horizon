class_name AttributesMenu extends Node

@export var points_label: Label
@export var container: VBoxContainer
@export var menu_entry_template: PackedScene

signal attribute_points_depleted
signal attribute_points_available

var character: PlayerCombatant
var entries: Array[AttributeMenuEntry]
var draft_points: int = 0

var character_changed: Signal

func initialize(_character_changed: Signal):
	character_changed = _character_changed
	character_changed.connect( update_and_render )
	spawn_entries_for_attributes()
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	set_draft_points( character.available_attribute_points )

func attribute_upgraded():
	set_draft_points( draft_points - 1)

func attribute_downgraded():
	set_draft_points( draft_points + 1)

func set_draft_points(points: int):
	draft_points = points
	if (draft_points == 0):
		emit_signal("attribute_points_depleted")
	elif (draft_points > 0):
		emit_signal("attribute_points_available")
	update_points_label()
	
func update_points_label():
	points_label.text = "Available attribute points: "
	points_label.text += str(draft_points)

func spawn_entries_for_attributes():
	for attribute in StatTypes.new().attributes():
		var entry := menu_entry_template.instantiate() as AttributeMenuEntry
		entry.initialize(
			attribute, character_changed, attribute_points_depleted, attribute_points_available)
		entry.attribute_upgraded.connect( attribute_upgraded )
		entry.attribute_downgraded.connect( attribute_downgraded )
		entries.append(entry)
		container.add_child(entry)
