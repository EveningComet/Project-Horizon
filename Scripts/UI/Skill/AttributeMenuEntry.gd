class_name AttributeMenuEntry extends HBoxContainer

@export var attribute_label: Label
@export var upgrade_button: Button
@export var downgrade_button: Button

var stat_types := StatTypes.new()
var attribute: StatTypes.stat_types

var stat: Stat
var draft_stat: Stat = null
var increase_amount: int = 0

func initialize(_attribute: StatTypes.stat_types, _character_changed: Signal):
	attribute = _attribute
	_character_changed.connect( update_and_render )
	upgrade_button.button_down.connect( upgrade )
	downgrade_button.button_down.connect( downgrade )

func update_and_render(character: PlayerCombatant):
	stat = character.stats[attribute]
	draft_stat = character.stats[attribute]
	increase_amount = character.get_attributes_increase()[attribute]
	set_draft_points( stat.get_base_value() )

func upgrade():
	set_draft_points ( draft_stat.get_base_value() + increase_amount )

func downgrade():
	set_draft_points ( draft_stat.get_base_value() - increase_amount )

func set_draft_points(points: int):
	draft_stat.set_base_value( points )
	update_label()

func update_label():
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += "-" if draft_stat == null else str( draft_stat.get_base_value() )
