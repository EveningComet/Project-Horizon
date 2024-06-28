@tool
## Stores data for a class that a player character can be.
class_name CharacterClass extends Resource

const STARTING_LEVEL := 1

## The name for the class.
@export var localization_name: String = "New Class"
@export_multiline var localization_description: String = "New description."

# Starting attributes
@export var starting_vitality:  int = 10
@export var starting_expertise: int = 10
@export var starting_will:      int = 10

# Growth on leveling up
@export var vitality_on_increase:  int = 5
@export var expertise_on_increase: int = 5
@export var will_on_increase:      int = 5

@export var starting_equipment: Array[ItemData] = []

## The skills available to this character class. Only attach to the "root" skill.
@export_category("Skills")
## Allows for a quick way to update the skills used by this job.
@export var file_path_to_job_skills: String

## Forces the system to update the stored skills.
@export var update_attached_skills: bool:
	set(value):
		read_skills()
		
@export var skills: Array[SkillData] = []

## Template for the skill tree associated with this job.
@export var skill_tree_prefab: PackedScene

@export_category("Portraits")
@export var male_portraits:   Array[PortraitData] = []
@export var female_portraits: Array[PortraitData] = []

## Returns the stats on increase as a dictionary.
func get_upgrade_attributes() -> Dictionary:
	return{
		StatTypes.stat_types.Vitality  : vitality_on_increase,
		StatTypes.stat_types.Expertise : expertise_on_increase,
		StatTypes.stat_types.Will      : will_on_increase
	}

func get_portraits() -> Array[PortraitData]:
	var portraits: Array[PortraitData] = []
	for mp in male_portraits:
		portraits.append(mp)
	for fp in female_portraits:
		portraits.append(fp)
	return portraits

## Read the skill data objects at the stored directory and add them to the skills
## this job can use.
func read_skills() -> void:
	skills.clear()
	var dir = DirAccess.open( file_path_to_job_skills )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name.is_empty() == false:
			if file_name.ends_with(".tres") == true:
				var found_skill: SkillData = load(
					file_path_to_job_skills + "/" + file_name
				)
				skills.append( found_skill )
			file_name = dir.get_next()
		dir.list_dir_end()
