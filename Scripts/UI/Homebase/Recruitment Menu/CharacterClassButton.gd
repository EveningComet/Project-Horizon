## Stores a character class to allow the player to recruit a character.
class_name CharacterClassButton extends Button

## Emitted when the player selects this button. This will pass the stored
## character class to the player.
signal on_player_selected_class(pc_class: CharacterClass)

var stored_class: CharacterClass = null

func setup_button(new_class: CharacterClass) -> void:
	stored_class = new_class
	text = stored_class.localization_name
	button_down.connect( on_pressed )

func on_pressed() -> void:
	on_player_selected_class.emit( stored_class )
