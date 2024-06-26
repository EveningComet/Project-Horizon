## The screen responsible for naming and renaming characters. It doesn't do
## anything on its own, so listeners will need to check for events.
class_name CharacterNameInputScreen extends Control

## Fired when the player finishes entering a name for the player.
signal player_finished_entering_name()

@export var randomize_name_button: BaseButton = null

## Convenience for when the player doesn't want to enter the name.
@export var accept_name_button: BaseButton = null

## The node storing the entered name.
@export var name_entry: LineEdit

## The current player character the player is naming or renaming.
var current_character: PlayerCombatant

var previous_name: String = ""

func _ready() -> void:
	name_entry.text_submitted.connect( on_text_submitted )
	randomize_name_button.button_down.connect( on_randomize_name_button_pressed )
	accept_name_button.pressed.connect( on_accept_name_button_pressed )
	
func start_accepting_input(new_character: PlayerCombatant) -> void:
	current_character = new_character
	show()
	name_entry.grab_focus()

func close() -> void:
	hide()
	name_entry.clear()
	current_character = null

func on_text_submitted(new_text: String) -> void:
	# Prevent moving on without at least one thing for the character's name
	if name_entry.text.length() < 1:
		return
	current_character.set_char_name( name_entry.text )
	player_finished_entering_name.emit()

func on_randomize_name_button_pressed() -> void:
	var name: String = Database.get_male_name()
	if Database.is_male_portrait(current_character.portrait_data) == true:
		name = Database.get_male_name()
		while previous_name == name:
			name = Database.get_male_name()
	if Database.is_female_portrait(current_character.portrait_data) == true:
		name = Database.get_female_name()
		while previous_name == name:
			name = Database.get_female_name()
	name_entry.set_text(name)
	previous_name = name

func on_accept_name_button_pressed() -> void:
	on_text_submitted( name_entry.text )
