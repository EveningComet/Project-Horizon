## Displays the vitals for a character. Doubles as a middleman for accessing
## a character's data.
class_name CombatantBattleUI extends Control

## The instance of the combatant currently being monitored.
@export var combatant: Combatant

## Used by enemies to display their portrait.
@export var portrait: TextureRect

@export var damage_text_template: PackedScene

@export var is_player_controlled: bool = false

@export var hp_display_text: RichTextLabel
@export var sp_display_text: RichTextLabel

## Stores a copy of the character's vitals for showing the differences.
var vital_stats: Dictionary = {} 

## Set the new combatant to monitor and update the displays if needed.
func set_combatant(new_combatant: Combatant, is_player_owned: bool) -> void:
	combatant            = new_combatant
	is_player_controlled = is_player_owned
	vital_stats[StatTypes.stat_types.CurrentHP] = combatant.get_current_hp()
	vital_stats[StatTypes.stat_types.CurrentSP] = combatant.get_current_sp()
	combatant.stat_changed.connect( on_stat_changed )
	if is_player_controlled == true:
		update_hp_display()
		update_sp_display()
	else:
		# Set the proper sprite/portrait for the enemy
		var enemy = new_combatant as EnemyCombatant
		portrait.set_texture( enemy.stored_enemy_data.portrait )

func on_stat_changed(monitored: Combatant) -> void:
	if is_player_controlled == true:
		update_hp_display()
		update_sp_display()
	
	# Handling for the enemy
	else:
		if vital_stats[StatTypes.stat_types.CurrentHP] > combatant.get_current_hp():
			var diff: int = combatant.get_current_hp() - vital_stats[StatTypes.stat_types.CurrentHP]
			diff = absi(diff)
			vital_stats[StatTypes.stat_types.CurrentHP] = combatant.get_current_hp()
			var damage_display_text: DamageTextDisplayer = damage_text_template.instantiate()
			get_parent().get_parent().add_child( damage_display_text )
			damage_display_text.global_position = global_position
			damage_display_text.display( diff )
			
		elif vital_stats[StatTypes.stat_types.CurrentHP] < combatant.get_current_hp():
			var diff: int = combatant.get_current_hp() - vital_stats[StatTypes.stat_types.CurrentHP]
			diff = absi(diff)
			vital_stats[StatTypes.stat_types.CurrentHP] = combatant.get_current_hp()
			var damage_display_text: DamageTextDisplayer = damage_text_template.instantiate()
			get_parent().get_parent().add_child( damage_display_text )
			damage_display_text.global_position = global_position
			damage_display_text.set("theme_override_colors/font_color", Color.GREEN)
			damage_display_text.display( diff )
		
		if monitored.stats[StatTypes.stat_types.CurrentHP] <= 0:
			queue_free()

func get_combatant() -> Combatant:
	return combatant

func update_hp_display() -> void:
	hp_display_text.set_text(
		"HP: %s / %s" % [combatant.get_current_hp(), combatant.get_max_hp()]
	)

func update_sp_display() -> void:
	sp_display_text.set_text(
		"SP: %s / %s" % [combatant.get_current_sp(), combatant.get_max_sp()]
	)
