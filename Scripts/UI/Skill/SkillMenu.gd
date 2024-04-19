class_name SkillMenu extends Control

@export var tab_bar: TabBar
@export var exit_button: Button
@export var confirm_button: Button
@export var undo_skill_points_button: Button
@export var skill_points_label: Label
@export var canvas: CanvasLayer
@export var skills_tree_renderer: SkillsTreeRenderer
@export var attributes_menu: AttributesMenu
@export var class_upgrade_menu: ClassUpgradeMenu

signal skill_points_depleted
signal character_changed(character: PlayerCombatant)

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant
var draft_available_skill_points

func _ready():
	add_tabs_per_character()
	visibility_changed.connect( on_visibility_changed )
	tab_bar.tab_changed.connect( render_tab )
	exit_button.button_down.connect( canvas.hide )
	confirm_button.button_down.connect( confirm_points )
	undo_skill_points_button.button_down.connect( undo_points )
	skills_tree_renderer.initialize( on_skill_upgraded, skill_points_depleted )
	attributes_menu.initialize( character_changed )
	class_upgrade_menu.initialize( character_changed )

func add_tabs_per_character():
	tab_bar.clear_tabs()
	for character in characters:
		var tab_name = "[" + character.pc_class.localization_name + "] " + character.char_name
		tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if (visible):
		render_tab( tab_bar.current_tab )

func render_tab(index: int):
	if (PlayerPartyController.has_members()):
		current_character = characters[index]
		emit_signal("character_changed", current_character)
		skills_tree_renderer.start(current_character.skill_holder.skills())
		set_draft_skill_points( current_character.available_skill_points )

func confirm_points():
	current_character.available_skill_points = draft_available_skill_points
	set_draft_skill_points( current_character.available_skill_points )
	get_tree().call_group( skills_tree_renderer.skills_group_name, "confirm" )

func undo_points():
	set_draft_skill_points( current_character.available_skill_points )
	get_tree().call_group( skills_tree_renderer.skills_group_name, "undo" )

func on_skill_upgraded():
	set_draft_skill_points( draft_available_skill_points - 1 )

func set_draft_skill_points(new_value: int):
	draft_available_skill_points = new_value
	if (draft_available_skill_points == 0):
		emit_signal("skill_points_depleted")
	set_draft_skill_points_label()
	disable_confirm_and_undo_if_no_action_taken()

func set_draft_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

func disable_confirm_and_undo_if_no_action_taken():
	var no_action_taken: bool = draft_available_skill_points == current_character.available_skill_points
	confirm_button.disabled = no_action_taken
	undo_skill_points_button.disabled = no_action_taken
