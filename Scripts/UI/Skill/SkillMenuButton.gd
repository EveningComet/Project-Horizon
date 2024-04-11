class_name SkillMenuButton extends TextureButton

var skill: SkillInstance
var description_label: RichTextLabel

func _init(_skill: SkillInstance, _description_label: RichTextLabel):
	skill = _skill
	description_label = _description_label

func _ready():
	texture_normal = skill.monitored_skill.display_texture
	button_down.connect(show_description)
	description_label.hide()

func show_description():
	description_label.text = get_formatted_skill_text()
	description_label.show()

func get_formatted_skill_text() -> String:
	var text = "[b]" + skill.monitored_skill.localization_name + "[/b]"
	text += "\n"
	text += skill.monitored_skill.localization_description
	return text
