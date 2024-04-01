## The screen responsible for naming and renaming characters. It doesn't do
## anything on its own, so listeners will need to check for events.
class_name CharacterNameInputScreen extends Control

## Fired when the player finishes entering a name for the player.
signal player_finished_entering_name()

## The node storing the entered name.
@export var name_entry: LineEdit

## The current player character the player is naming or renaming.
var current_character: PlayerCombatant

func _ready() -> void:
	name_entry.text_submitted.connect( on_text_submitted )
	
func start_accepting_input(new_character: PlayerCombatant) -> void:
	current_character = new_character
	show()
	name_entry.grab_focus()

func close() -> void:
	hide()
	name_entry.clear()
	current_character = null

# TODO: Maybe there should be a button the player should click on when they're done entering a name?

func on_text_submitted(new_text: String) -> void:
	current_character.set_char_name( name_entry.text )
	print("CharacterNameInput :: The new character's name is %s and their class is: %s." % [current_character.char_name, current_character.pc_class.localization_name])
	player_finished_entering_name.emit()
