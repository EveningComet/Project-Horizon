class_name SkillMenu extends Control

signal skill_points_depleted
signal skill_points_available
signal character_changed(character: PlayerCombatant)

@export var character_tab_bar: TabBar
@export var class_tabs:  TabBar
@export var exit_button: Button
@export var confirm_button: Button
@export var undo_skill_points_button: Button
@export var skill_points_label: Label
@export var canvas: CanvasLayer
@export var skills_tree_renderer: SkillsTreeRenderer
@export var attributes_menu: AttributesMenu
@export var class_upgrade_menu: ClassUpgradeMenu
@export var attributes_upgrader: AttributesUpgrader

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant
var draft_available_skill_points

func _ready():
	add_tabs_per_character()
	visibility_changed.connect( on_visibility_changed )
	character_tab_bar.tab_changed.connect( render_tab )
	exit_button.button_down.connect( canvas.hide )
	confirm_button.button_down.connect( confirm_points )
	undo_skill_points_button.button_down.connect( undo_points )
	skills_tree_renderer.initialize( deduct_one_point, skill_points_depleted )
	attributes_upgrader.initialize( character_changed )
	attributes_menu.initialize( character_changed )
	class_upgrade_menu.initialize( 
		character_changed, skill_points_depleted, skill_points_available )
	attributes_upgrader.class_upgraded.connect( deduct_one_point )

func add_tabs_per_character():
	character_tab_bar.clear_tabs()
	for character in characters:
		var tab_name = character.char_name
		character_tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if visible == true:
		render_tab( character_tab_bar.current_tab )

func render_tab(index: int):
	if PlayerPartyController.has_members() == true:
		current_character = characters[index]
		emit_signal("character_changed", current_character)
		skills_tree_renderer.start( current_character.skill_holder.skill_branches )
		set_draft_skill_points( current_character.available_skill_points )

func confirm_points():
	attributes_upgrader.confirm()
	get_tree().call_group( skills_tree_renderer.skills_group_name, "confirm" )
	current_character.available_skill_points = draft_available_skill_points
	# Set this last, as the buttons upgrade based on skill point signal 
	set_draft_skill_points( current_character.available_skill_points )

func undo_points():
	attributes_upgrader.undo()
	get_tree().call_group( skills_tree_renderer.skills_group_name, "undo" )
	# Set this last, as the buttons upgrade based on skill point signal 
	set_draft_skill_points( current_character.available_skill_points )

func deduct_one_point():
	set_draft_skill_points( draft_available_skill_points - 1 )

func set_draft_skill_points(new_value: int):
	draft_available_skill_points = new_value
	emit_correct_signal()
	set_draft_skill_points_label()
	disable_confirm_and_undo_if_no_action_taken()

func emit_correct_signal():
	if (draft_available_skill_points == 0):
		emit_signal("skill_points_depleted")
	else:
		emit_signal("skill_points_available")

func set_draft_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

func disable_confirm_and_undo_if_no_action_taken():
	var no_action_taken: bool = draft_available_skill_points == current_character.available_skill_points
	confirm_button.disabled = no_action_taken
	undo_skill_points_button.disabled = no_action_taken
