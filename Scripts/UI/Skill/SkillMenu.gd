class_name SkillMenu extends Control

@export var tab_bar: TabBar
@export var exit_button: Button
@export var undo_skill_points_button: Button
@export var skill_container: HBoxContainer
@export var skill_points_label: Label
@export var skill_menu_button_template: PackedScene

var characters:= PlayerPartyController.party_members

# Called when the node enters the scene tree for the first time.
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
	var character:= characters[index]
	show_skills(character)
	set_available_skill_points_label(character)

func show_skills(character: PlayerCombatant):
	clear_skills()
	for skill in character.skill_holder.skills:
		var button := skill_menu_button_template.instantiate() as SkillMenuButton
		button.initialize( skill )
		button.disabled = character.available_skill_points == 0
		skill_container.add_child( button )

func set_available_skill_points_label(character: PlayerCombatant):
	skill_points_label.text = "Available skill points: " + str(character.available_skill_points)

func clear_skills():
	for child in skill_container.get_children():
		skill_container.remove_child( child )
		child.queue_free()
