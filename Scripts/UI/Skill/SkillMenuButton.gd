class_name SkillMenuButton extends TextureButton

var skill: SkillInstance
@export var level_label: Label

func initialize(_skill: SkillInstance):
	skill = _skill
	texture_normal = skill.monitored_skill.display_texture
	tooltip_text = get_formatted_skill_text()
	level_label.text = str(skill.current_upgrade_level) + "/" + str(skill.monitored_skill.max_rank)

func get_formatted_skill_text() -> String:
	var text = skill.monitored_skill.localization_name + ": "
	text += skill.monitored_skill.localization_description
	return text
