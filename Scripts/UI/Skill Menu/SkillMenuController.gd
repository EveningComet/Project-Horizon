## Controls all aspects of the skills menu.
class_name SkillMenuController extends Node

signal skill_points_available
signal skill_points_depleted
signal character_changed(character: PlayerCombatant)
signal class_changed(new_class: CharacterClass)

@export var tree_container: Container

@export var character_tab_bar: TabBar
@export var class_tabs:  TabBar
@export var exit_button: Button
@export var undo_skill_points_button: Button
@export var skill_points_label: Label
@export var canvas: CanvasLayer
@export var attributes_menu: AttributesMenu
@export var class_upgrade_menu: ClassUpgradeMenu
@export var attributes_upgrader: AttributesUpgrader

var characters:= PlayerPartyController.party_members
var current_character: PlayerCombatant
var draft_available_skill_points: int = 0

## Stores the recent history of the skill points the player has alloted.
var alloted_history: Array = []

func _ready() -> void:
	setup()

func setup() -> void:
	add_tabs_per_character()
	undo_skill_points_button.pressed.connect( on_undo_skill_points_button_pressed )
	canvas.visibility_changed.connect( on_visibility_changed )

func add_tabs_per_character():
	character_tab_bar.clear_tabs()
	for character in characters:
		var tab_name = character.char_name
		character_tab_bar.add_tab( tab_name )

func on_visibility_changed():
	if canvas.visible == true:
		on_character_tab_changed( character_tab_bar.current_tab )
	else:
		alloted_history.clear() # Make any previously set upgrades permanent

func on_character_tab_changed(index: int):
	if PlayerPartyController.has_members() == true:
		# Refresh the alloted history
		alloted_history.clear()
		
		class_tabs.clear_tabs()
		current_character = characters[index]
		set_draft_skill_points( current_character.available_skill_points )
		character_changed.emit( current_character )
		
		undo_skill_points_button.disabled = true if draft_available_skill_points == 0 else false
		
		# Create the needed tabs for character classes
		for cc: CharacterClass in current_character.pc_classes:
			var tab_name = cc.localization_name
			class_tabs.add_tab( tab_name )
		on_character_class_tab_changed(0)

## When the player changes a tab related to a character's class, show the
## proper skills.
func on_character_class_tab_changed(index: int) -> void:
	if tree_container.get_child_count() > 0:
		tree_container.get_child(0).queue_free()
	
	var classes_as_array: Array = current_character.pc_classes.keys()
	var desired_class: CharacterClass = classes_as_array[index]
	var class_skill_tree: SkillTree = desired_class.skill_tree_prefab.instantiate()
	tree_container.add_child(class_skill_tree)
	var scroll_container = tree_container as ScrollContainer
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
	
	# Hook up the skill instances
	var instances = get_skill_instances_of_class(desired_class)
	class_skill_tree.combine_instances_to_nodes(instances)
	class_skill_tree.update_upgradability_status(current_character)
	
	# Connect to the upgrade events
	var existing_skill_nodes = class_skill_tree.existing_skill_nodes
	for n: SkillNode in existing_skill_nodes:
		n.upgraded.connect( on_upgrade_occurred )

## Get the skills of the class for the current character.
func get_skill_instances_of_class(desired_class: CharacterClass) -> Array[SkillInstance]:
	var class_skills: Array[SkillInstance] = []
	for s: SkillInstance in current_character.skill_holder.skills.keys():
		if desired_class.skills.has(s.skill) == true:
			class_skills.append(s)
	return class_skills

func set_draft_skill_points(new_value: int):
	draft_available_skill_points = new_value
	update_draft_skill_points_label()

func update_draft_skill_points_label():
	skill_points_label.text = "Available skill points: "
	skill_points_label.text += str( draft_available_skill_points )

## Handle what should happen when an upgrade happens here.
func on_upgrade_occurred(ui_upgradable: Object) -> void:
	if draft_available_skill_points == 0:
		return
		
	if ui_upgradable is SkillNode:
		var skill_node = ui_upgradable as SkillNode
		if skill_node.skill_instance.curr_rank == skill_node.associated_skill.max_rank:
			return
		skill_node.upgrade()
	
	alloted_history.append(ui_upgradable)
	draft_available_skill_points -= 1
	update_draft_skill_points_label()

## When the player selects the undo button, revert all the upgrades the player
## stored. Go through the list of stored upgrades and reverse them.
func on_undo_skill_points_button_pressed() -> void:
	# Go through the alloted history and undo the upgrades the player made
	while alloted_history.is_empty() == false:
		var upgrade_to_remove = alloted_history.pop_back()
		if upgrade_to_remove is SkillNode:
			var skill_node: SkillNode = upgrade_to_remove as SkillNode
			skill_node.downgrade()
		draft_available_skill_points += 1
		update_draft_skill_points_label()
