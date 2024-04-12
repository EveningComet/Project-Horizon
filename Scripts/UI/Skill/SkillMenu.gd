class_name SkillMenu extends Control

@export var tab_bar: TabBar
@export var exit_button: Button
@export var confirm_button: Button
@export var undo_skill_points_button: Button
@export var skill_container: HBoxContainer
@export var skill_points_label: Label
@export var skill_menu_button_template: PackedScene

const skills_group_name := "skills"

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant
var draft_available_skill_points

func _ready():
	add_tabs_per_character()
	visibility_changed.connect( on_visibility_changed )
	tab_bar.tab_changed.connect( render_tab )
	exit_button.button_down.connect( hide )
	confirm_button.button_down.connect( confirm_points )
	undo_skill_points_button.button_down.connect( undo_points )

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
	set_available_skill_points( current_character.available_skill_points )

func confirm_points():
	current_character.available_skill_points = draft_available_skill_points
	set_available_skill_points( current_character.available_skill_points )
	get_tree().call_group( skills_group_name, "confirm" )

func undo_points():
	set_available_skill_points( current_character.available_skill_points )
	get_tree().call_group( skills_group_name, "undo" )

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
	undo_skill_points_button.disabled = false
	confirm_button.disabled = false
	set_available_skill_points( draft_available_skill_points - 1 )
	set_available_skill_points_label()

func set_available_skill_points(new_value: int):
	draft_available_skill_points = new_value
	set_available_skill_points_label()
	disable_skills_if_no_points_left()
	disable_confirm_and_undo_if_no_action_taken()

func set_available_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

func disable_skills_if_no_points_left():
	var function_name = "disable" if draft_available_skill_points == 0 else "enable"
	get_tree().call_group( skills_group_name, function_name )

func disable_confirm_and_undo_if_no_action_taken():
	var no_action_taken: bool = draft_available_skill_points == current_character.available_skill_points
	confirm_button.disabled = no_action_taken
	undo_skill_points_button.disabled = no_action_taken

func clear_skills():
	for child in skill_container.get_children():
		skill_container.remove_child( child )
		child.queue_free()
