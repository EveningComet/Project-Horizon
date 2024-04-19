## Stores a character class to allow the player to recruit a character.
class_name CharacterClassButton extends Button

## Fired when the player focuses or highlights this button in the menu.
signal player_highlighted_character_class_button(char_class: CharacterClass)

## Emitted when the player selects this button. This will pass the stored
## character class to the player.
signal player_selected_class(pc_class: CharacterClass)

## The class this button is keeping track of.
var stored_class: CharacterClass = null

func setup_button(new_class: CharacterClass) -> void:
	stored_class = new_class
	text = stored_class.localization_name
	button_down.connect( on_pressed )
	mouse_entered.connect( on_mouse_entered )
	focus_entered.connect( on_focused )

func on_pressed() -> void:
	player_selected_class.emit( stored_class )

func on_focused() -> void:
	player_highlighted_character_class_button.emit( stored_class )

func on_mouse_entered() -> void:
	player_highlighted_character_class_button.emit( stored_class )
