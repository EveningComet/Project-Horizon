class_name SkillMenuButton extends TextureButton

var skill: SkillInstance
var draft_level

@export var level_label: Label

signal skill_upgraded()

func initialize(_skill: SkillInstance, _points_depleted_signal: Signal):
	skill = _skill
	skill.subscribe_skill_unlocked( enable_button_if_possible )
	button_down.connect( upgrade_skill )
	_points_depleted_signal.connect( disable )
	set_correct_texture_and_text()
	
func disable():
	disabled = true
	apply_grayscale()

func enable():
	disabled = false
	unapply_grayscale()

func upgrade_skill():
	set_upgrade_level( draft_level + 1 )
	emit_signal( "skill_upgraded" )

func confirm():
	skill.upgrade_to_level( draft_level )

func undo():
	set_upgrade_level( skill.current_upgrade_level )

func set_correct_texture_and_text():
	texture_normal = skill.monitored_skill.display_texture
	tooltip_text = get_formatted_skill_text()
	set_upgrade_level( skill.current_upgrade_level )

func set_upgrade_level(new_value: int):
	draft_level = new_value
	set_level_text()
	enable_button_if_possible()

func set_level_text():
	level_label.text = str( draft_level ) + "/" + str( skill.monitored_skill.max_rank )

func get_formatted_skill_text() -> String:
	var text = skill.monitored_skill.localization_name + ": "
	text += skill.monitored_skill.localization_description
	return text
	
func apply_grayscale():
	modulate = Color(0.6, 0.6, 0.6, 1)
	
func unapply_grayscale():
	modulate = Color(1, 1, 1, 1)

func enable_button_if_possible():
	var is_maxed_out: bool = draft_level >= skill.monitored_skill.max_rank
	if (skill.is_unlocked and not is_maxed_out):
		enable()
	else:
		disable()
