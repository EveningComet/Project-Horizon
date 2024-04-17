## Represents an item in an inventory.
class_name ItemSlotUI extends PanelContainer

## Fired when the player clicks on this slot to allow adding/removing items
signal slot_clicked(index: int, button: int)

## The visual of the item that will be displayed.
@export var icon: TextureRect

## Visualizes the quantity of the item to the player.
@export var amount_label: Label

func _ready() -> void:
	gui_input.connect( on_gui_input )

func set_slot_data(slot_data: ItemSlotData) -> void:
	var item: ItemData = slot_data.stored_item
	icon.set_texture( item.image )
	
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()

func on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			slot_clicked.emit(get_index(), event.button_index) 
