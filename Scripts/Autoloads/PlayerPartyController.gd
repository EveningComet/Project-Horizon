## Responsible for holding the player's party.

extends Node

## The maximum number of party members the player can have in their party, not
## including summons.
const MAX_RECRUITABLE_SIZE: int = 6

## THe maxinum number of members, including summons, that the player can have.
const MAX_LIMIT: int = 12

var party_members: Array[PlayerCombatant] = []

func has_members() -> bool:
	return get_party_count() > 0

func is_party_fightable() -> bool:
	if has_members() == false:
		return false
	
	for pm in party_members:
		if pm.get_current_hp() > 0:
			return true
	return false

func get_party_count() -> int:
	return party_members.size()

func add_party_member(pm_to_add: PlayerCombatant) -> void:
	party_members.append( pm_to_add )

func add_at_index(pm_to_add: PlayerCombatant, index: int) -> void:
	party_members.insert( index, pm_to_add ) 

func remove_party_member(pm_to_remove: PlayerCombatant) -> void:
	party_members.erase( pm_to_remove )

func fully_restore_hp_and_sp_of_party() -> void:
	for pm: PlayerCombatant in party_members:
		pm.fully_restore_hp_and_sp()
