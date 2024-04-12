class_name StatTypes

enum stat_types {
	# Attributes
	Vitality,             # For health, defense, etc.
	Expertise,            # For physical damage, etc.
	Will,                 # For mind, special points, etc.
	
	# Vitals
	MaxHP,                # Max hit points
	CurrentHP,            # Current hit points
	MaxSP,                # Our max mana/stamina/etc.
	CurrentSP,            # Our current mana/stamina/etc.
	
	# Other stats
	Defense,              # Reduces damage
	Perception,           # (Hit chance) = Expertise + Will
	Evasion,              # (Dodge)      = Vitality  + Expertise
	Speed,                # (Vitality + Will) / 2
	CriticalHitChance
}
