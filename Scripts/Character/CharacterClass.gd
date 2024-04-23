## Stores data for a class that a player character can be.
class_name CharacterClass extends Resource

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

## The skills available to this character class.
@export var skills: Array[SkillData] = []

@export_category("Portraits")
@export var male_portraits:   Array[PortraitData] = []
@export var female_portraits: Array[PortraitData] = []

func get_portraits() -> Array[PortraitData]:
	var portraits: Array[PortraitData] = []
	for mp in male_portraits:
		portraits.append(mp)
	for fp in female_portraits:
		portraits.append(fp)
	return portraits
