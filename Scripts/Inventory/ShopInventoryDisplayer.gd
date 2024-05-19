## Alternative version of inventory displayer that plays nicer with shops.
class_name ShopInventoryDisplayer extends InventoryDisplayer

## Helps with what items should be displayed.
@export var tab_bar: TabBar

func set_slot_data(slot: ItemSlotUI, slot_data: ItemSlotData) -> void:
	var index: int = inventory_to_display.stored_items.find(slot_data)
	slot.set_char_inspection_window( character_inspection_window )
	slot.set_slot_data( slot_data, index )
