class_name AttributeMenuEntry extends HBoxContainer

@export var attribute_label: Label
@export var upgrade_button: Button
@export var downgrade_button: Button

signal attribute_upgraded
signal attribute_downgraded

var stat_types := StatTypes.new()
var attribute: StatTypes.stat_types
var upgrader: AttributesUpgrader

func initialize(
	_attribute: StatTypes.stat_types, _upgrader: AttributesUpgrader,
	_points_depleted: Signal, _points_available: Signal):
	
	attribute = _attribute
	upgrader = _upgrader
	upgrader.stats_changed.connect( update_and_render )
	upgrader.stats_confirmed.connect( update_and_render )
	_points_depleted.connect( disable_upgrade )
	_points_available.connect( enable_upgrade )
	upgrade_button.button_down.connect( upgrade )
	downgrade_button.button_down.connect( downgrade )

func update_and_render(stats: Dictionary):
	update_label(stats[attribute])
	downgrade_button.disabled = upgrader.is_minimum_reached(attribute)

func disable_upgrade():
	upgrade_button.disabled = true

func enable_upgrade():
	upgrade_button.disabled = false

func upgrade():
	upgrader.upgrade(attribute)
	emit_signal( "attribute_upgraded" )

func downgrade():
	upgrader.downgrade(attribute)
	emit_signal( "attribute_downgraded" )

func confirm():
	upgrader.confirm()

func update_label(points: int):
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += str( points )
