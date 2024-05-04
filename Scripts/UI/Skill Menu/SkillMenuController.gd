## Controls all aspects of the skills menu.
class_name SkillMenuController extends Node

signal skill_points_available
signal skill_points_depleted
signal character_changed(character: PlayerCombatant)
signal class_changed(new_class: CharacterClass)

@export var character_tab_bar: TabBar
@export var class_tabs:  TabBar
@export var exit_button: Button
@export var confirm_button: Button
@export var undo_skill_points_button: Button
@export var skill_points_label: Label
@export var canvas: CanvasLayer
@export var skill_tree_renderer: SkillTreeRenderer
@export var attributes_menu: AttributesMenu
@export var class_upgrade_menu: ClassUpgradeMenu
@export var attributes_upgrader: AttributesUpgrader

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant
var draft_available_skill_points

func _ready() -> void:
	add_tabs_per_character()
	canvas.visibility_changed.connect( on_visibility_changed )
	skill_tree_renderer.skill_buttons_finished_rendering.connect(
		on_skills_finished_spawning
	)
	character_tab_bar.tab_changed.connect( on_character_tab_changed )
	class_tabs.tab_changed.connect( on_character_class_tab_changed )
	exit_button.button_down.connect( canvas.hide )
	confirm_button.button_down.connect( confirm_points )
	undo_skill_points_button.button_down.connect( undo_points )
	attributes_menu.initialize( character_changed )
	
	class_upgrade_menu.initialize( 
		class_changed, skill_points_depleted, skill_points_available
	)
	attributes_upgrader.initialize( character_changed, class_changed )
	attributes_upgrader.class_upgraded.connect( deduct_one_point )

func add_tabs_per_character():
	character_tab_bar.clear_tabs()
	for character in characters:
		var tab_name = character.char_name
		character_tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if canvas.visible == true:
		on_character_tab_changed( character_tab_bar.current_tab )

func on_character_tab_changed(index: int):
	if PlayerPartyController.has_members() == true:
		class_tabs.clear_tabs()
		current_character = characters[index]
		set_draft_skill_points( current_character.available_skill_points )
		character_changed.emit( current_character )
		
		# Create the needed tabs for character classes
		for cc: CharacterClass in current_character.pc_classes:
			var tab_name = cc.localization_name
			class_tabs.add_tab( tab_name )
		on_character_class_tab_changed(0)

## When the player changes a tab related to a character's class, show the
## proper skills.
func on_character_class_tab_changed(index: int) -> void:
	# Convert the character's stored classes to an array and index that array
	var classes_as_array: Array[CharacterClass]
	for class_key: CharacterClass in current_character.pc_classes:
		classes_as_array.append(class_key)
	var desired_class: CharacterClass = classes_as_array[index]
	
	# Get the skills of that class and then display the skill instances
	var skill_instances: Array[SkillInstance] = get_skill_instances_of_class(
		desired_class
	)
	skill_tree_renderer.display_skill_instances(
		skill_instances
	)
	
	class_changed.emit( desired_class )

## Get the skills of the class for the current character.
func get_skill_instances_of_class(desired_class: CharacterClass) -> Array[SkillInstance]:
	var skill_instances: Array[SkillInstance] = []
	for skill: SkillData in desired_class.skills:
		var d: Dictionary = current_character.skill_holder.skill_data_instances
		skill_instances.append( d[skill] )
	return skill_instances

## Fired when the skills tree renderer has finished spawning all the buttons.
func on_skills_finished_spawning() -> void:
	if draft_available_skill_points > 0:
		var stbs = get_tree().get_nodes_in_group(skill_tree_renderer.SKILL_TREE_BUTTON_GROUP_NAME)
		var skill_buttons: Array[SkillTreeButton]
		skill_buttons.append_array( stbs )
		for b in skill_buttons:
			b.enable_button_if_possible()
			b.skill_upgraded.connect( on_skill_upgraded )
	else:
		get_tree().call_group(skill_tree_renderer.SKILL_TREE_BUTTON_GROUP_NAME, "disable")

func on_skill_upgraded(skill_instance: SkillInstance) -> void:
	deduct_one_point()

func confirm_points():
	attributes_upgrader.confirm()
	get_tree().call_group( skill_tree_renderer.SKILL_TREE_BUTTON_GROUP_NAME, "confirm" )
	current_character.available_skill_points = draft_available_skill_points
	# Set this last, as the buttons upgrade based on skill point signal 
	set_draft_skill_points( current_character.available_skill_points )

func undo_points():
	attributes_upgrader.undo()
	get_tree().call_group( skill_tree_renderer.SKILL_TREE_BUTTON_GROUP_NAME, "undo" )
	# Set this last, as the buttons upgrade based on skill point signal 
	set_draft_skill_points( current_character.available_skill_points )

func deduct_one_point():
	set_draft_skill_points( draft_available_skill_points - 1 )

func set_draft_skill_points(new_value: int):
	draft_available_skill_points = new_value
	set_draft_skill_points_label()
	emit_correct_signal()
	handle_confirm_and_undo()

func set_draft_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

func emit_correct_signal():
	if draft_available_skill_points == 0:
		skill_points_depleted.emit()
	else:
		skill_points_available.emit()
	
func handle_confirm_and_undo() -> void:
	if draft_available_skill_points == 0 or \
	draft_available_skill_points == current_character.available_skill_points:
		confirm_button.disabled           = true
		undo_skill_points_button.disabled = true
	else:
		confirm_button.disabled           = false
		undo_skill_points_button.disabled = false
