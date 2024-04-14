## Stores data for an enemy.
class_name EnemyData extends Resource

@export_category("Enemy Info")
@export var enemy_name: String = "New Enemy"

# The enemy's core attributes
@export var vitality:  int = 10
@export var expertise: int = 10
@export var will:      int = 10

@export var exp_on_death: int = 100

## The skills this enemy can use.
@export var available_skills: Array[SkillData] = []

@export_category("AI")
## Represents possible things an AI could do. Heal ally, attack enemy, etc.
@export var possible_decisions: Array[UtilityAIBehavior] = []
