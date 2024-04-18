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

# TODO: Portraits that are used for this class.

@export var starting_equipment: Array[ItemData] = []

## The skills available to this character class.
@export var skills: Array[SkillData] = []
