## Stores an instance of an item.
class_name ItemSlotData extends Resource

## The item being stored.
@export var stored_item: ItemData = null

## The amount of the item.
@export var quantity: int = 0:
	set(value):
		# Legalize the quantity
		quantity = value
		if quantity > 1 and stored_item.max_stack_size == 1:
			quantity = 1

## Remove and return one item of this.
func create_single_slot_data() -> ItemSlotData:
	var new_slot_data: ItemSlotData = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data
