## Represents a character for the party.
class_name PartyMemberHolderUI extends PanelContainer

signal slot_clicked(char_slot_data: PartyMemberHolderUI, index: int, button: int)

## The portrait for the character. (When the finalized art is used, this should
## be the cropped version of the character portrait.)
@export var portrait: TextureRect

## A quick way to prevent the drag and drop character ui from making the system
## go haywire.
@export var fires_tooltip_event: bool = true

## The character being monitored.
var stored_character: PlayerCombatant

func _ready() -> void:
	gui_input.connect( on_gui_input )
	mouse_entered.connect( on_mouse_entered )
	mouse_exited.connect( on_mouse_exited )

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

func on_mouse_entered() -> void:
	if fires_tooltip_event == true:
		EventBus.on_tooltip_needed(self)

func on_mouse_exited() -> void:
	EventBus.tooltip_hide.emit()
