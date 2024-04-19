class_name ClassUpgradeMenu extends Node

@export var info_container: VBoxContainer
@export var upgrade_button: Button

var info_labels:= {}
var class_name_label: Label

var stat_types := StatTypes.new()
var character: PlayerCombatant
var character_changed: Signal

func initialize(_character_changed: Signal):
	character_changed = _character_changed
	character_changed.connect( update_and_render )
	spawn_labels_for_attributes()
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	update_info_labels_text()

func update_info_labels_text():
	class_name_label.text = "Class: " + str(character.pc_class.localization_name).to_upper()
	for attribute in stat_types.attributes():
		info_labels[attribute].text = "> " + stat_types.stat_types_to_string[attribute]
		info_labels[attribute].text += " on upgrade: "
		info_labels[attribute].text += str(character.get_attributes_increase()[attribute])
	
func spawn_labels_for_attributes():
	class_name_label = Label.new()
	info_container.add_child( class_name_label )
	for attribute in stat_types.attributes():
		var label := Label.new()
		info_labels[attribute] = label
		info_container.add_child( label )
		
	
