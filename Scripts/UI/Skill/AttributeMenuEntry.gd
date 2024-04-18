class_name AttributeMenuEntry extends HBoxContainer

@export var attribute_label: Label
@export var upgrade_button: Button
@export var downgrade_button: Button

signal attribute_upgraded
signal attribute_downgraded

var stat_types := StatTypes.new()
var attribute: StatTypes.stat_types

var stat: Stat
var draft_points: int = 0
var increase_amount: int = 0

func initialize(
	_attribute: StatTypes.stat_types,
	_character_changed: Signal, _points_depleted: Signal, _points_available: Signal):
	
	attribute = _attribute
	_character_changed.connect( update_and_render )
	_points_depleted.connect( disable_upgrade )
	_points_available.connect( enable_upgrade )
	upgrade_button.button_down.connect( upgrade )
	downgrade_button.button_down.connect( downgrade )

func update_and_render(character: PlayerCombatant):
	stat = character.stats[attribute]
	draft_points = character.stats[attribute].get_base_value()
	increase_amount = character.get_attributes_increase()[attribute]
	set_draft_points( stat.get_base_value() )

func upgrade():
	set_draft_points ( draft_points + increase_amount )
	emit_signal("attribute_upgraded")

func downgrade():
	var new_amount := draft_points - increase_amount
	if (new_amount >= stat.get_base_value()):
		set_draft_points ( draft_points - increase_amount )
		emit_signal("attribute_downgraded")

func confirm():
	stat.set_base_value( draft_points )
	set_draft_points( stat.get_base_value() )

func set_draft_points(points: int):
	draft_points = points
	update_label()
	disable_downgrade_if_minimum_reached()

func enable_upgrade():
	upgrade_button.disabled = false

func disable_upgrade():
	upgrade_button.disabled = true
	
func disable_downgrade_if_minimum_reached():
	downgrade_button.disabled = draft_points <= stat.get_base_value()

func update_label():
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += str( draft_points )
