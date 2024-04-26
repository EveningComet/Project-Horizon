## Deals with upgrading the class.
class_name ClassUpgradeMenu extends Node

signal class_upgraded

@export var info_container: VBoxContainer
@export var upgrade_button: Button
@export var upgrader: AttributesUpgrader

var info_labels:= {}
var class_name_label: Label

var stat_types := StatTypes.new()
var current_class: CharacterClass

func initialize(
	_class_changed_signal: Signal,
	_points_depleted_signal: Signal,
	_points_available_signal: Signal
	) -> void:
	
	_class_changed_signal.connect( update_and_render )
	_points_depleted_signal.connect( disable_upgrade )
	_points_available_signal.connect( enable_upgrade )
	upgrade_button.button_down.connect( upgrade )
	upgrader.class_upgraded.connect( update_class_name_label )
	upgrader.stats_undone.connect( update_class_name_label )
	spawn_labels_for_attributes()

func update_and_render(_class: CharacterClass):
	current_class = _class
	update_info_labels()

func disable_upgrade():
	upgrade_button.disabled = true

func enable_upgrade():
	upgrade_button.disabled = false

func upgrade():
	upgrader.class_upgrade(
		current_class
	)

func update_info_labels():
	update_class_name_label()
	for attribute in stat_types.attributes():
		info_labels[attribute].text = "> " + stat_types.stat_types_to_string[attribute]
		info_labels[attribute].text += " on upgrade: "
		info_labels[attribute].text += str( 
			current_class.get_upgrade_attributes()[attribute]
		)

func update_class_name_label():
	class_name_label.text = "Class: "
	class_name_label.text += str( current_class.localization_name ).to_upper()
	class_name_label.text += "- Lvl: "
	class_name_label.text += str( upgrader.classes_and_class_levels[current_class] )

func spawn_labels_for_attributes():
	class_name_label = Label.new()
	info_container.add_child( class_name_label )
	for attribute in stat_types.attributes():
		var label := Label.new()
		info_labels[attribute] = label
		info_container.add_child( label )
