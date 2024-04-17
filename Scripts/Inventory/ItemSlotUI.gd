## Represents an item in an inventory.
class_name ItemSlotUI extends PanelContainer

## The visual of the item that will be displayed.
@export var icon: TextureRect

## Visualizes the quantity of the item to the player.
@export var amount_label: Label

func set_slot_data(slot_data: ItemSlotData) -> void:
	var item: ItemData = slot_data.stored_item
	icon.set_texture( item.image )
	
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()
