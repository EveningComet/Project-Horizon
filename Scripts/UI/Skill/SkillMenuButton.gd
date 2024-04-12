class_name SkillMenuButton extends TextureButton

var skill: SkillInstance
var description_label: RichTextLabel

func initialize(_skill: SkillInstance, _description_label: RichTextLabel):
	skill = _skill
	description_label = _description_label
	texture_normal = skill.monitored_skill.display_texture
	description_label.hide()

func _ready():
	button_down.connect(show_description)

func show_description():
	description_label.text = get_formatted_skill_text()
	description_label.show()

func get_formatted_skill_text() -> String:
	var text = "[b]" + skill.monitored_skill.localization_name + "[/b]"
	text += "\n"
	text += skill.monitored_skill.localization_description
	return text
