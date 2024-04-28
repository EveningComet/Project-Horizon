## Handles displaying the skill tree.
class_name SkillTreeRenderer extends Node

signal skill_buttons_finished_rendering
const SKILL_TREE_BUTTON_GROUP_NAME : String = "Skill Tree Buttons"

@export var branches_container: VBoxContainer
@export var stb_template: PackedScene

# {button : leaves}
var root_to_leaves: Dictionary = {}

var visited_skill_instances: Dictionary = {}

## Display the passed skill instances.
func display_skill_instances(skill_instances: Array[SkillInstance]) -> void:
	clear_skills()
	
	for root_skill: SkillInstance in skill_instances:
		var root_container: HBoxContainer = spawn_branch(root_skill)
		branches_container.add_child(root_container)
	
	await get_tree().create_timer(0.01).timeout
	finish()
	
	# Tell anything that needs to know about the spawned buttons
	skill_buttons_finished_rendering.emit()

func spawn_branch(root_skill: SkillInstance) -> HBoxContainer:
	var root_container := HBoxContainer.new()
	
	# Use depth first search to iterate over the leaves
	var stack:   Array[SkillInstance] = []
	visited_skill_instances[root_skill] = true
	stack.append(root_skill)
	
	var root_button: SkillTreeButton = make_skill_button(root_skill)
	root_container.add_child(root_button)
	root_to_leaves[root_button] = []
	
	while stack.is_empty() == false:
		# Get the current skill
		var current_skill: SkillInstance = stack.pop_front()
		if visited_skill_instances.has(current_skill) == false:
			visited_skill_instances[current_skill] = true
			root_button = make_skill_button(root_skill)
			root_container.add_child(root_button)
			root_to_leaves[root_button] = []
		
		# Go through the "nearby" skills of the current skill
		for neighbor: SkillInstance in current_skill.branched_skills:
			var current_child: SkillInstance = neighbor
			if visited_skill_instances.has(current_child) == false:
				stack.append(current_child)
				visited_skill_instances[current_child] = true
				
				# TODO: The logic here is correct, just not for the UI.
				# Account for multiple branches.
				
				# Found a skill that needs a button
				var new_button: SkillTreeButton = make_skill_button(current_child)
				root_to_leaves[root_button].append(new_button)
				root_container.add_child(new_button)
	
	return root_container

func finish():
	for root in root_to_leaves.keys():
		if root_to_leaves[root].is_empty() == false:
			draw_lines_to_all_unlockables_from(root)

func draw_lines_to_all_unlockables_from(root: SkillTreeButton):
	# Use dfs to draw the nodes
	var visited: Dictionary = {}
	visited[root] = true
	var stack: Array[SkillTreeButton]
	stack.append(root)
	
	while stack.is_empty() == false:
		var current: SkillTreeButton = stack.pop_front()
		for neighbor in root_to_leaves[root]:
			var current_child = neighbor
			if visited.has(current_child) == false:
				stack.append(current_child)
				visited[current_child] = true
				
				# Found a target to draw to
				var line = spawn_connecting_line(current, current_child)
				fade_in(line)
				current_child.get_parent().add_child(line)

func spawn_connecting_line(begin: SkillTreeButton, end: SkillTreeButton) -> Line2D:
	var line := Line2D.new()
	line.add_point( center_position( begin ) )
	line.add_point( center_position( end ) )
	line.z_index = -1 # push line to background
	line.default_color = Color(125, 125, 125)
	return line

func center_position(item: CanvasItem):
	return item.position + item.size / 2

func fade_in(item: CanvasItem):
	var target_modulate := item.modulate
	item.modulate = Color(1, 1, 1, 0)
	var tween:= get_tree().create_tween()
	tween.tween_property( item, "modulate", target_modulate , 0.5 )

func make_skill_button(skill: SkillInstance) -> SkillTreeButton:
	var button := stb_template.instantiate() as SkillTreeButton
	button.initialize( skill )
	button.add_to_group( SKILL_TREE_BUTTON_GROUP_NAME )
	return button

func clear_skills():
	root_to_leaves.clear()
	visited_skill_instances.clear()
	for child in branches_container.get_children():
		branches_container.remove_child( child )
		child.queue_free()
