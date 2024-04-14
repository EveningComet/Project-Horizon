## This node spawns the skills tree
## by spawning the buttons and their connecting lines
class_name SkillsTreeRenderer extends Node

@export var skill_container: HBoxContainer
@export var skill_menu_button_template: PackedScene
@export var wait_skills_render_timer: Timer
@export var skills_group_name : String = "skills"

# Dictionary { skill_data : skill_menu_button }
var button_per_skill = {}

var on_skill_upgraded: Callable
var skill_points_depleted: Signal

func _ready():
	# The buttons must first render before we can get their position for drawing lines
	wait_skills_render_timer.timeout.connect( finish )

func initialize(_on_skill_upgraded: Callable, _skill_points_depleted: Signal):
	on_skill_upgraded = _on_skill_upgraded
	skill_points_depleted = _skill_points_depleted

func start(skills: Array):
	clear_skills()
	for skill in skills:
		var button:= make_skill_button( skill ) as SkillMenuButton
		button_per_skill[skill.monitored_skill] = button
		skill_container.add_child( button )
	wait_skills_render_timer.start() 

func finish():
	for skill_data in button_per_skill.keys():
		if (not skill_data.unlockable.is_empty()):
			draw_lines_to_all_unlockables_from( button_per_skill[skill_data] )

func draw_lines_to_all_unlockables_from(button: SkillMenuButton):
	var skill_data := button.skill.monitored_skill
	var unlockables := skill_data.unlockable
	for unlockable in unlockables:
		var target := button_per_skill[unlockable] as SkillMenuButton
		var line := spawn_connecting_line(button, target)
		fade_in( line )
		skill_container.add_child(line)

func spawn_connecting_line(begin: SkillMenuButton, end: SkillMenuButton) -> Line2D:
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

func make_skill_button(skill: SkillInstance) -> SkillMenuButton:
	var button := skill_menu_button_template.instantiate() as SkillMenuButton
	button.initialize( skill, skill_points_depleted )
	button.add_to_group( skills_group_name )
	button.skill_upgraded.connect( on_skill_upgraded )
	return button

func clear_skills():
	for child in skill_container.get_children():
		button_per_skill = {}
		skill_container.remove_child( child )
		child.queue_free()
