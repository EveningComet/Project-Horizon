## Stores data for how a skill should be upgraded overtime.
class_name SkillUpgrade extends Resource

## The cost of the skill for this upgrade tier. Could be higher, could be lower.
@export var new_cost: int = 5

## THe power scale for this tier.
@export var new_power_scale: float = 1.0

## The newer, more powerful version of the permanent upgrade.
@export var new_stat_modifier: StatModifier = null
