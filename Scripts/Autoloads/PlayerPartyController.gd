## Responsible for holding the player's party.

extends Node

## The maximum number of party members the player can have in their party, not
## including summons.
const MAX_RECRUITABLE_SIZE: int = 6

## THe maxinum number of members, including summons, that the player can have.
const MAX_LIMIT: int = 12

var party_members: Array[PlayerCombatant] = []

func get_party_count() -> int:
	return party_members.size()

func add_party_member(pm_to_add: PlayerCombatant) -> void:
	party_members.append( pm_to_add )

func remove_party_member(pm_to_remove: PlayerCombatant) -> void:
	party_members.erase( pm_to_remove )
