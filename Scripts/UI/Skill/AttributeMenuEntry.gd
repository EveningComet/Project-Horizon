class_name AttributeMenuEntry extends HBoxContainer

@export var attribute_label: Label
@export var upgrade_button: Button
@export var downgrade_button: Button

var draft_points := 0
var stat_types := StatTypes.new()

var attribute: StatTypes.stat_types
var stat: Stat

func initialize(_attribute: StatTypes.stat_types, _character_changed: Signal):
	attribute = _attribute
	_character_changed.connect(render)
	update_label()

func render(character: PlayerCombatant):
	stat = character.stats[attribute]
	draft_points = stat.get_base_value()
	update_label()

func update_label():
	attribute_label.text = stat_types.stat_types_to_string[attribute]
	attribute_label.text += ": "
	attribute_label.text += str(draft_points)
