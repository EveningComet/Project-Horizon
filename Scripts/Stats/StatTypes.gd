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
	Perception,           # (Hit chance) = Expertise + Will and bonuses
	Evasion,              # (Dodge)      = Vitality  + Expertise and bonuses
	Speed,                # (Vitality + Will and bonuses) / 2
	CriticalHitChance,
	PhysicalPower,
	SpecialPower
}

# Below function and variable should be static. This is a workaround.
# Because Godot Editor will complain about static function not found
# Even though function is declared and code runs without any runtime errors
func attributes() -> Array[stat_types]:
	return [ stat_types.Vitality, stat_types.Expertise, stat_types.Will ]

var stat_types_to_string:= {
	stat_types.Vitality : "Vitality",
	stat_types.Expertise : "Expertise",
	stat_types.Will : "Will"
}
