class_name ClassUpgradeMenu extends Node

@export var info_container: VBoxContainer
@export var upgrade_button: Button
@export var upgrader: AttributesUpgrader

signal class_upgraded

var info_labels:= {}
var class_name_label: Label

var stat_types := StatTypes.new()
var character: PlayerCombatant
var character_changed: Signal

func initialize(
	_character_changed: Signal,
	_points_depleted_signal: Signal, _points_available_signal: Signal):

	character_changed = _character_changed
	character_changed.connect( update_and_render )
	_points_depleted_signal.connect( disable_upgrade )
	_points_available_signal.connect( enable_upgrade )
	upgrade_button.button_down.connect( upgrade )
	spawn_labels_for_attributes()
	
func update_and_render(_character: PlayerCombatant):
	character = _character
	update_info_labels_text()

func disable_upgrade():
	upgrade_button.disabled = true

func enable_upgrade():
	upgrade_button.disabled = false

func upgrade():
	upgrader.class_upgrade(character.get_attributes_increase())
	emit_signal("class_upgraded")

func undo():
	upgrader.undo_class_upgrade()

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
		
	
