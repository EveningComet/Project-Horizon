class_name SkillMenu extends Control

@export var tab_bar: TabBar
@export var exit_button: Button
@export var skill_container: HBoxContainer
@export var skill_description_label: RichTextLabel

var characters:= PlayerPartyController.party_members

# Called when the node enters the scene tree for the first time.
func _ready():
	add_tabs_per_character()
	visibility_changed.connect( on_visibility_changed )
	tab_bar.tab_changed.connect( show_skills )
	exit_button.button_down.connect( hide )

func on_visibility_changed():
	if (visible):
		show_skills(tab_bar.current_tab)

func show_skills(index: int):
	clear_skills()
	var character:= characters[index]
	for skill in character.skill_holder.skills:
		var button = SkillMenuButton.new(skill, skill_description_label)
		skill_container.add_child(button)

func add_tabs_per_character():
	tab_bar.clear_tabs()
	for character in characters:
		tab_bar.add_tab(character.char_name)

func clear_skills():
	for child in skill_container.get_children():
		skill_container.remove_child(child)
		child.queue_free()
