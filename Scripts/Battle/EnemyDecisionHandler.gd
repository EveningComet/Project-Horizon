## Responsible for deciding what enemies should do.
class_name EnemyDecisionHandler extends Node

func handle_enemy_turn(
	enemies: Array[EnemyCombatant],
	player_party: Array[PlayerCombatant]
) -> void:
	
	# The actions that will be sent
	var actions_to_send: Array[StoredAction] = []
	
	for enemy in enemies:
		var action: StoredAction = _get_best_action_for_enemy(
			enemy,
			enemies,
			player_party
		)
		
		actions_to_send.append( action )
	
	# The enemy has finished the job, move on
	EventBus.side_finished_turn.emit( actions_to_send )

## Get the best decision for the passed enemy.
func _get_best_action_for_enemy(
	enemy: EnemyCombatant, 
	enemy_allies: Array[EnemyCombatant],
	player_party: Array[PlayerCombatant]
) -> StoredAction:
	var choices: Array[UtilityAIOption] = []
	for behavior: UtilityAIBehavior in enemy.stored_enemy_data.behaviors:
		
		# Set up all the necessary data that can be used for the context
		# beforehand
		var context: Dictionary = {
			"target_hp": 0,     # Could be enemy or player char hp
			"enemy_party_hp":  _get_party_hp(enemy_allies),
			"player_party_hp": _get_party_hp(player_party),
			"base_defense": 0,
			"potential_damage": 0,
			"skill_cost": 0,
			"current_sp": enemy.stats[StatTypes.stat_types.CurrentSP],
			"healilng_power": 0
		}
		
		match behavior.name:
			# TODO: Checks to make sure the enemy has enough sp for the move.
			"Attack Single Weakest":
				for player_com: PlayerCombatant in player_party:
					# Generate a new stored action
					var potential_action: StoredAction = StoredAction.new()
					potential_action.activator = enemy
					potential_action.add_target( player_com )
					
					# Update the needed context information
					context["target_hp"] = player_com.stats[StatTypes.stat_types.CurrentHP]
					context["base_defense"] = player_com.get_defense()
					
					# Find the skill that will deal the most damage
					for skill: SkillData in enemy.stored_enemy_data.available_skills:
						var mediator = skill.get_usable_data( enemy )
						potential_action.skill_instance = SkillInstance.new()
						potential_action.skill_instance.monitored_skill = skill
						context["potential_damage"] = mediator.damage_data["base_damage"]
						var choice = UtilityAIOption.new(
							behavior, context, potential_action
						)
						choices.append( choice )
						
			"Attack Healer":
				pass
			
			"Heal Ally":
				for enemy_ally: EnemyCombatant in enemy_allies:
					var potential_action: StoredAction = StoredAction.new()
					potential_action.activator = enemy
					potential_action.add_target( enemy_ally )
					potential_action.action_type = ActionTypes.ActionTypes.SingleAlly
					context["target_hp"] = enemy_ally.stats[StatTypes.stat_types.CurrentHP]
					
					for skill: SkillData in enemy.stored_enemy_data.available_skills:
						var mediator = skill.get_usable_data( enemy )
						potential_action.skill_instance = SkillInstance.new()
						potential_action.skill_instance.monitored_skill = skill
						context["healing_power"] = mediator.heal_amount
						var choice = UtilityAIOption.new(
							behavior, context, potential_action
						)
						choices.append( choice )
	
	if OS.is_debug_build() == true:
		print("EnemyDecisionHandler :: Possible decisions for %s: %s" % [enemy.stored_enemy_data.enemy_name, choices])
	# Get and return an action
	var decision = UtilityAI.choose_highest(
		choices, 
		enemy.stored_enemy_data.efficiency
	)
	if OS.is_debug_build() == true:
		print_rich("[color=green]EnemyDecisionHandler :: Chosen decision: %s[/color]" % [decision])
	
	return decision.action as StoredAction

## Get the total hp for the passed party.
func _get_party_hp(combatants: Array) -> int:
	var total_hp: int = 0
	for comb: Combatant in combatants:
		total_hp += comb.stats[StatTypes.stat_types.CurrentHP]
	return total_hp
