## Instance of a character in a battle. Stores needed data.
class_name Combatant extends Node

# TODO: const scale variables for the health, sp, and other numbers?

## Called when a stat on this character has been changed.
signal stat_changed( combatant: Combatant )

# Scaling values
const VITALITY_HP_SCALER:              int = 3
const VITALITY_DEFENSE_SCALER:         int = 2
const WILL_SPECIAL_POINTS_SCALER:      int = 3
const WILL_SPECIAL_POWER_SCALER:       int = 2
const EXPERTISE_PHYSICAL_POWER_SCALER: int = 2

## Stores the stats for this character.
var stats: Dictionary = {}

## The status effects being monitored for this character.
var status_effect_holder: StatusEffectHolder = StatusEffectHolder.new()

## The equipment being monitored for this character.
var equipment_holder: EquipmentInventory = EquipmentInventory.new(self)

## The skills being monitored for this character.
var skill_holder: SkillHolder = SkillHolder.new()

## Initialize the stats. This version just gives base values.
func initialize() -> void:
	# Attributes
	stats[StatTypes.stat_types.Vitality] = Stat.new(
		7,
		true
	)
	stats[StatTypes.stat_types.Expertise] = Stat.new(
		7,
		true
	)
	stats[StatTypes.stat_types.Will]       = Stat.new(
		5,
		true
	)
	initialize_vitals()
	initialize_other_stats()

func initialize_vitals() -> void:
	# Vitals
	stats[StatTypes.stat_types.MaxHP] = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * VITALITY_HP_SCALER,
		true
	)
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * WILL_SPECIAL_POINTS_SCALER,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()

## Setup the other stats.
func initialize_other_stats() -> void:
	# This is the "bonus" base defense
	stats[StatTypes.stat_types.Defense] = Stat.new(
		0,
		true
	)
	
	# This is the "bonus" speed
	stats[StatTypes.stat_types.Speed] = Stat.new(
		0,
		true
	)
	
	# The "bonus" perception
	stats[StatTypes.stat_types.Perception] = Stat.new(
		0,
		true
	)
	
	# This is the "bonus" evasion
	stats[StatTypes.stat_types.Evasion] = Stat.new(
		0,
		true
	)
	
	# This is the "bonus" critical hit chance
	stats[StatTypes.stat_types.CriticalHitChance] = Stat.new(
		0,
		true
	)
	
	stats[StatTypes.stat_types.PhysicalPower] = Stat.new( 0, true )
	stats[StatTypes.stat_types.SpecialPower]  = Stat.new( 0, true )
	
	# TODO: Initialize the resistances for damage types

func get_max_hp() -> int:
	return floor(stats[StatTypes.stat_types.MaxHP].get_calculated_value())

func get_current_hp() -> int:
	return floor(stats[StatTypes.stat_types.CurrentHP])

func get_max_sp() -> int:
	return floor(stats[StatTypes.stat_types.MaxSP].get_calculated_value())

func get_current_sp() -> int:
	return floor(stats[StatTypes.stat_types.CurrentSP])

# TODO: Figure out how to distinguish between ranged?
## Get the "true" physical power for a character.
func get_physical_power() -> int:
	var expertise: int = stats[StatTypes.stat_types.Expertise].get_calculated_value()
	var true_physical_power: Stat = Stat.new(expertise * EXPERTISE_PHYSICAL_POWER_SCALER, true)
	for mod: StatModifier in stats[StatTypes.stat_types.PhysicalPower].get_modifiers():
		true_physical_power.add_modifier( mod )
	return true_physical_power.get_calculated_value()

## Get the "true" special power for a character.
func get_special_power() -> int:
	var will: int = stats[StatTypes.stat_types.Will].get_calculated_value() * WILL_SPECIAL_POWER_SCALER
	var true_special_power: Stat = Stat.new(will, true)
	for mod: StatModifier in stats[StatTypes.stat_types.SpecialPower].get_modifiers():
		true_special_power.add_modifier( mod )
	return true_special_power.get_calculated_value()

## Return the "true" perception, which is used for the chance to hit.
func get_perception() -> int:
	var expertise: int = stats[StatTypes.stat_types.Expertise].get_calculated_value()
	var will:      int = stats[StatTypes.stat_types.Will].get_calculated_value()
	var true_perception: Stat = Stat.new(expertise + will, true)
	for mod: StatModifier in stats[StatTypes.stat_types.Perception].get_modifiers():
		true_perception.add_modifier( mod )
	return floor( true_perception.get_calculated_value() )

## Return the "true" base defense for this character.
func get_defense() -> int:
	var vitality:     int  = stats[StatTypes.stat_types.Vitality].get_calculated_value()
	var true_defense: Stat = Stat.new(vitality * VITALITY_DEFENSE_SCALER, true)
	for mod: StatModifier in stats[StatTypes.stat_types.Defense].get_modifiers():
		true_defense.add_modifier( mod )
	return floor( true_defense.get_calculated_value() )

## Returns the "true" evasion for a character.
func get_evasion() -> int:
	var vitality:  int = stats[StatTypes.stat_types.Vitality].get_calculated_value()
	var expertise: int = stats[StatTypes.stat_types.Expertise].get_calculated_value()
	var true_evasion: Stat = Stat.new(vitality + expertise, true)
	for mod: StatModifier in stats[StatTypes.stat_types.Evasion].get_modifiers():
		true_evasion.add_modifier( mod )
	return floor( true_evasion.get_calculated_value() )

## Get the true critical hit chance for a character.
func get_crit_chance() -> int:
	var expertise: int = stats[StatTypes.stat_types.Expertise].get_calculated_value()
	var true_crit_chance: Stat = Stat.new(expertise, true)
	for mod: StatModifier in stats[StatTypes.stat_types.CriticalHitChance].get_modifiers():
		true_crit_chance.add_modifier( mod )
	return floor( true_crit_chance.get_calculated_value() )

## Gets the "true" speed for a character, which takes into account the
## character's base speed and modifiers.
func get_speed() -> int:
	var vitality: int = stats[StatTypes.stat_types.Vitality].get_calculated_value()
	var will:     int = stats[StatTypes.stat_types.Will].get_calculated_value()
	var true_speed: Stat = Stat.new(vitality + will, true)
	for mod: StatModifier in stats[StatTypes.stat_types.Speed].get_modifiers():
		true_speed.add_modifier( mod )
	return floor( true_speed.get_calculated_value() / 2 )

## Wrapper for permanently increasing the base value of a particular stat.
## Mainly used to raise a character's attributes.
func raise_base_value_by(stat_raising: StatTypes.stat_types, amt: int) -> void:
	stats[stat_raising].raise_base_value_by(amt)
	check_if_max_vital_values_need_updating()
	stat_changed.emit(self)

func add_modifier(stat_type: StatTypes.stat_types, mod_to_add: StatModifier) -> void:
	stats[stat_type].add_modifier( mod_to_add )
	check_if_max_vital_values_need_updating()
	stat_changed.emit( self )

func remove_modifier(stat_type: StatTypes.stat_types, mod_to_remove: StatModifier) -> void:
	stats[stat_type].remove_modifier( mod_to_remove )
	check_if_max_vital_values_need_updating()
	stat_changed.emit( self )

func check_if_max_vital_values_need_updating() -> void:
	var true_max_hp: Stat = Stat.new(
		stats[StatTypes.stat_types.Vitality].get_calculated_value() * VITALITY_HP_SCALER,
		true
	)
	var true_max_sp: Stat = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * WILL_SPECIAL_POINTS_SCALER,
		true
	)
	
	for hp_mod: StatModifier in stats[StatTypes.stat_types.MaxHP].get_modifiers():
		true_max_hp.add_modifier( hp_mod )
	for sp_mod: StatModifier in stats[StatTypes.stat_types.MaxSP].get_modifiers():
		true_max_sp.add_modifier( sp_mod )
	
	stats[StatTypes.stat_types.MaxHP] = true_max_hp
	stats[StatTypes.stat_types.MaxSP] = true_max_sp
	
	if get_current_hp() > get_max_hp():
		stats[StatTypes.stat_types.CurrentHP] = get_max_hp()
	if get_current_sp() > get_max_sp():
		stats[StatTypes.stat_types.CurrentSP] = get_max_sp()

func take_damage(dmg_amount: int) -> void:
	# TODO: Check for damage types, such as fire, psychic, etc.
	dmg_amount -= get_defense()
	if dmg_amount < 1:
		dmg_amount = 1
	
	stats[StatTypes.stat_types.CurrentHP] -= dmg_amount
	stat_changed.emit( self )
	if stats[StatTypes.stat_types.CurrentHP] <= 0:
		die()

func fully_restore_hp_and_sp() -> void:
	stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()

func heal(heal_amount: int) -> void:
	stats[StatTypes.stat_types.CurrentHP] += heal_amount
	if stats[StatTypes.stat_types.CurrentHP] > stats[StatTypes.stat_types.MaxHP].get_calculated_value():
		stats[StatTypes.stat_types.CurrentHP] = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	
	stat_changed.emit( self )

func sub_sp(amount_to_lose: int) -> void:
	stats[StatTypes.stat_types.CurrentSP] -= amount_to_lose
	stats[StatTypes.stat_types.CurrentSP] = max(
		stats[StatTypes.stat_types.CurrentSP],
		0
	)
	stat_changed.emit( self )

func regain_sp(gain_amount: int) -> void:
	stats[StatTypes.stat_types.CurrentSP] += gain_amount
	if stats[StatTypes.stat_types.CurrentSP] > stats[StatTypes.stat_types.MaxSP].get_calculated_value():
		stats[StatTypes.stat_types.CurrentSP] = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
		
	stat_changed.emit( self )

## When this character dies, notify anything that needs to know about it.
## Child classes will override this.
func die() -> void:
	EventBus.hp_depleted.emit( self )
