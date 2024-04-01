## Responsible for giving experience points to the player's characters when
## enemies die or quests are completed.
class_name ExperienceHandler
extends Node

## Stores the player's characters that will be given experience.
@export var party_members: Array[PlayerCombatant] = []
