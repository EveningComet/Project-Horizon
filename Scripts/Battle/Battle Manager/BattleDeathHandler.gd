## Keeps track of character's dying in battles.
class_name BattleDeathHandler extends Node

## The node housing all the characters that need to be tracked of in battle
@export var spawned_combatants_node: Node

var results: Dictionary = {}

## Keeps track of the experience points that should be given to the player
## characters after winning a battle.
var experience_points_to_give: int = 0

func _ready() -> void:
	EventBus.hp_depleted.connect( on_combatant_hp_depleted )

func refresh() -> void:
	results.clear()
	experience_points_to_give = 0

func on_combatant_hp_depleted(combatant: Combatant) -> void:
	if combatant is EnemyCombatant:
		var enemy                  = combatant as EnemyCombatant
		experience_points_to_give += enemy.experience_to_give_on_death
		enemy.queue_free()
		
		# Check if all the enemies have been defeated
		for c in spawned_combatants_node.get_children():
			if c is EnemyCombatant and enemy.is_queued_for_deletion() == false:
				return
		
		# All of the enemies have been defeated
		if OS.is_debug_build() == true:
			print("DeathHandler :: All enemies have been defeated.")
		results["player_victory"]              = true
		results["experience_points_to_reward"] = experience_points_to_give
	
	# TODO: Handling the player characters falling in combat.

func get_rewarded_experience_points() -> int:
	return experience_points_to_give
