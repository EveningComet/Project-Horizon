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
	set_draft_points( stat.get_base_value() )

func disable_upgrade():
	upgrade_button.disabled = true

func enable_upgrade():
	upgrade_button.disabled = false

func upgrade():
	set_draft_points ( draft_points + 1 )
	emit_signal( "attribute_upgraded" )

func downgrade():
	var is_at_minimum := draft_points == stat.get_base_value()
	if (not is_at_minimum):
		set_draft_points ( draft_points - 1 )
		emit_signal( "attribute_downgraded" )

func set_draft_points(points: int):
	draft_points = points
	update_label()
	disable_downgrade_if_minimum_reached()

func confirm():
	stat.set_base_value( draft_points )
	set_draft_points( stat.get_base_value() )

func refresh():
	set_draft_points( stat.get_base_value() )
	
func disable_downgrade_if_minimum_reached():
	downgrade_button.disabled = draft_points <= stat.get_base_value()

func update_label():
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += str( draft_points )
