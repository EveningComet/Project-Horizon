class_name SkillMenuButton extends TextureButton

var skill: SkillInstance
var draft_level

@export var level_label: Label

signal skill_upgraded()

func initialize(_skill: SkillInstance):
	skill = _skill
	button_down.connect( upgrade_skill )
	set_correct_texture_and_text()
	enable_button_if_skill_unlocked()
	
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
	skill.current_upgrade_level = draft_level

func undo():
	set_upgrade_level( skill.current_upgrade_level )

func enable_button_if_skill_unlocked():
	if (skill.is_unlocked):
		enable()
	else:
		disable()

func set_correct_texture_and_text():
	texture_normal = skill.monitored_skill.display_texture
	tooltip_text = get_formatted_skill_text()
	set_upgrade_level( skill.current_upgrade_level )

func set_upgrade_level(new_value: int):
	draft_level = new_value
	set_level_text()

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
