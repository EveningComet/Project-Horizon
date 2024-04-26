## Represents a character for the party.
class_name PartyMemberHolderUI extends PanelContainer

signal slot_clicked(char_slot_data: PartyMemberHolderUI, index: int, button: int)

## The character being monitored.
@export var stored_character: PlayerCombatant

## The portrait for the character. (When the finalized art is used, this should
## be the cropped version of the character portrait.)
@export var portrait: TextureRect

func _ready() -> void:
	gui_input.connect( on_gui_input )

## Set the character being tracked of.
func set_character(recruited_character: PlayerCombatant) -> void:
	stored_character = recruited_character
	portrait.set_texture( stored_character.portrait_data.small_portrait )

func on_gui_input(event: InputEvent) -> void:
	# Drag and drop code
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			slot_clicked.emit(self, get_index(), event.button_index) 
