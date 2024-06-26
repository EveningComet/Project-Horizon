## Stores data for an enemy.
class_name EnemyData extends Resource

@export_category("Enemy Info")
## The thing used to display what this enemy looks like.
@export var portrait: Texture2D

@export var enemy_name: String = "New Enemy"

# The enemy's core attributes
@export var vitality:  int = 10
@export var expertise: int = 10
@export var will:      int = 10

@export var exp_on_death: int = 100

## Used for giving the enemy better or worse stats.
@export var stat_modifiers: Array[StatModifier] = []

## The skills this enemy can use.
@export var available_skills: Array[SkillData] = []

@export_category("AI")
## How "brutal" an enemy is between 0 and 1. Higher values mean the enemy
## will perform the better action more often.
@export_range(0.0, 1.0) var efficiency: float = 0.25

## Represents possible things an AI could do. Heal ally, attack enemy, etc.
@export var behaviors: Array[UtilityAIBehavior] = []
