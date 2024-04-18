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
	for attribute in StatTypes.new().attributes():
		var entry := menu_entry_template.instantiate()
		entry.initialize(attribute, character_changed)
		entries.append(entry)
		container.add_child(entry)
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	print("AttributesMenu: ", character.char_name)
	render()

func render():
	pass
