## A button that gets displayed in the battle skills menu.
class_name BattleSkillMenuButton extends Button

## The skill that this button keeps track of.
var activatable_skill: SkillData = null

func set_skill(skill_to_set: SkillData) -> void:
	activatable_skill = skill_to_set
	text = skill_to_set.localization_name

func get_skill() -> SkillData:
	return activatable_skill
