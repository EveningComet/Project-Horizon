class_name AttributesMenu extends Node

@export var points_label: Label
@export var container: VBoxContainer
@export var menu_entry_template: PackedScene

var character: PlayerCombatant
var entries: Array[AttributeMenuEntry]
var character_changed: Signal

func initialize(_character_changed: Signal):
	character_changed = _character_changed
	character_changed.connect( update_and_render )
	spawn_entries_for_attributes()
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	render()

func render():
	points_label.text = "Available attribute points: "
	points_label.text += str(character.available_attribute_points)

func spawn_entries_for_attributes():
	for attribute in StatTypes.new().attributes():
		var entry := menu_entry_template.instantiate()
		entry.initialize(attribute, character_changed)
		entries.append(entry)
		container.add_child(entry)
