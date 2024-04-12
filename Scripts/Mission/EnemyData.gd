## Stores data for an enemy.
class_name EnemyData extends Resource

@export var enemy_name: String = "New Enemy"

# The enemy's core attributes
@export var vitality:  int = 10
@export var expertise: int = 10
@export var will:      int = 10

@export var exp_on_death: int = 100

## The skills this enemy can use.
@export var skills: Array[SkillData] = []
