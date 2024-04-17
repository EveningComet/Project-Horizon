## Responsible for displaying the name and value of a particular stat.
class_name CharacterStatDisplayer extends Control

@export var stat_name_label:  Label
@export var stat_value_label: Label

func update_display(stat_name: String, stat_value: String) -> void:
	stat_name_label.set_text( stat_name )
	stat_value_label.set_text( stat_value)
