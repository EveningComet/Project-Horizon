## Keeps track of character's dying in battles.
class_name BattleDeathHandler extends Node

## The node housing all the characters that need to be tracked of in battle
@export var spawned_combatants_node: Node

var results: Dictionary = {}

## The characters being kept track of.
var spawned_combatants: Array[Combatant] = []

func _ready() -> void:
	EventBus.hp_depleted.connect( on_combatant_hp_depleted )

func refresh() -> void:
	results.clear()

func on_combatant_hp_depleted(combatant: Combatant) -> void:
	if combatant is EnemyCombatant:
		spawned_combatants.erase( combatant )
		var enemy                  = combatant as EnemyCombatant
		enemy.queue_free()
		
		# Check if all the enemies have been defeated
		for c in spawned_combatants:
			if c is EnemyCombatant:
				return
		
		# All of the enemies have been defeated
		if OS.is_debug_build() == true:
			print("DeathHandler :: All enemies have been defeated.")
		results["player_victory"]              = true
	
	if combatant is PlayerCombatant:
		for c in spawned_combatants:
			if c is PlayerCombatant and c.stats[StatTypes.stat_types.CurrentHP] > 0:
				return
		
		# At this point, it's safe to say the player lost
		if OS.is_debug_build() == true:
			print("DeathHandler :: The player has lost.")
		results["player_victory"]              = false

func on_combatant_spawned(combatant: Combatant) -> void:
	spawned_combatants.append( combatant )
