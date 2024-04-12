class_name SkillMenu extends Control

@export var tab_bar: TabBar
@export var exit_button: Button
@export var undo_skill_points_button: Button
@export var skill_container: HBoxContainer
@export var skill_points_label: Label
@export var skill_menu_button_template: PackedScene

const skills_group_name := "skills"

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant

func _ready():
	add_tabs_per_character()
	visibility_changed.connect( on_visibility_changed )
	tab_bar.tab_changed.connect( render_tab )
	exit_button.button_down.connect( hide )

func add_tabs_per_character():
	tab_bar.clear_tabs()
	for character in characters:
		var tab_name = "[" + character.pc_class.localization_name + "] " + character.char_name
		tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if (visible):
		render_tab( tab_bar.current_tab )

func render_tab(index: int):
	current_character = characters[index]
	show_skills()
	check_available_skill_points()
	set_available_skill_points_label()

func show_skills():
	clear_skills()
	for skill in current_character.skill_holder.skills:
		var button:= make_skill_button( skill )
		skill_container.add_child( button )

func make_skill_button(skill: SkillInstance) -> SkillMenuButton:
	var button := skill_menu_button_template.instantiate() as SkillMenuButton
	button.initialize( skill )
	button.add_to_group( skills_group_name )
	button.skill_upgraded.connect( on_skill_upgraded )
	return button

func on_skill_upgraded():
	current_character.available_skill_points -= 1
	set_available_skill_points_label()
	check_available_skill_points()

func check_available_skill_points():
	if (current_character.available_skill_points == 0):
		get_tree().call_group( skills_group_name, "disable" )

func set_available_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( current_character.available_skill_points )

func clear_skills():
	for child in skill_container.get_children():
		skill_container.remove_child( child )
		child.queue_free()
