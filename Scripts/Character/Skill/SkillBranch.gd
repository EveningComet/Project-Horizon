class_name SkillBranch

var skills: Array[SkillInstance] = []

func starting_skill() -> SkillInstance:
    return null if skills.is_empty() else skills[0]