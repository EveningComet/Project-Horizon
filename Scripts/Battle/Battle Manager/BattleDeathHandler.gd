## Keeps track of character's dying in battles.
class_name BattleDeathHandler extends Node

## Keeps track of the experience points that should be given to the player
## characters after winning a battle.
var experience_points_to_give: int = 0

func refresh() -> void:
	experience_points_to_give = 0

func on_player_character_death(player_character: Combatant) -> void:
	# Make it so that the character can't do anything until they've been revived.
	pass
	
func on_enemy_death(enemy: Combatant) -> void:
	enemy = enemy as EnemyCombatant
	experience_points_to_give += enemy.experience_to_give_on_death
	enemy.queue_free()

func check_if_battle_over() -> Dictionary:
	var victory_status: Dictionary = {}
	return victory_status

func get_rewarded_experience_points() -> int:
	return experience_points_to_give
