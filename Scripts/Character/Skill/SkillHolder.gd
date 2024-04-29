## Stores a collection of instanced skills.
class_name SkillHolder

## Dictionary { skill_data : skill_instance }
var skill_data_instances: = {}

func initialize_for_player_character(skill_class: CharacterClass):
	initialize_skill_data_instances( skill_class.skills )
	try_to_unlock_with_class_level(skill_class, 1)

func add_skills(skills_to_add: Array[SkillData]) -> void:
	initialize_skill_data_instances(skills_to_add)

func add_from_character_class(cc: CharacterClass) -> void:
	initialize_skill_data_instances( cc.skills )
	try_to_unlock_with_class_level( cc, 1 )

## Return all the stored skills.
func skills() -> Array:
	var results: Array = []
	var visited: Dictionary = {}
	# Use dfs to go through the skills
	for skill_instance: SkillInstance in skill_data_instances.values():
		
		var stack: Array[SkillInstance] = []
		visited[skill_instance] = true
		stack.append(skill_instance)
		while stack.is_empty() == false:
			var current: SkillInstance = stack.pop_front()
			for neighbor in current.branched_skills:
				if visited.has(neighbor) == false:
					visited[neighbor] = true
					stack.append(visited)

	return visited.keys()

func get_usable_skills() -> Array:
	var result = []
	var visited: Array = skills()
	for v in visited:
		var skill_instance = v as SkillInstance
		if skill_instance.current_upgrade_level > 0:
			result.append(v)
	
	return result

## Mainly for player characters.
func try_to_unlock_with_class_level(cc: CharacterClass, level: int):
	for skill in skill_data_instances:
		# TODO: This does not take branching into account!
		if cc.skills.has(skill) == true:
			var skill_instance = skill_data_instances[skill]
			skill_instance.try_to_unlock_with_class_level( level )

func try_to_relock_with_class_level(cc: CharacterClass, level: int) -> void:
	for skill in skill_data_instances:
		# TODO: This does not take branching into account!
		if cc.skills.has(skill) == true:
			var skill_instance = skill_data_instances[skill]
			skill_instance.try_to_relock_with_class_level( level )

func initialize_skill_data_instances(skills: Array[SkillData]):
	for data in skills:
		skill_data_instances[data] = SkillInstance.new()
		skill_data_instances[data].initialize( data )
