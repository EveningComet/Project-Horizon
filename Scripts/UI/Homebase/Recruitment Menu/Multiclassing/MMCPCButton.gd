## Stores a character from the player's party so that the player can select
## a new class for them.
class_name MMCPCButton extends Button

signal character_selected_for_multiclassing(character: PlayerCombatant)

## The character being kept track of.
var stored_character: PlayerCombatant:
	get:
		return stored_character
	set(value):
		stored_character = value
		set_text( stored_character.char_name )

func _ready() -> void:
	button_down.connect( on_button_down )

func on_button_down() -> void:
	character_selected_for_multiclassing.emit( stored_character )
