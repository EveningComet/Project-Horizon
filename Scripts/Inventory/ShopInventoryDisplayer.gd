## Alternative version of inventory displayer that plays nicer with shops.
class_name ShopInventoryDisplayer extends InventoryDisplayer

## Helps with what items should be displayed.
@export var tab_bar: TabBar

## Handles updating the display of the inventory.
func populate_items(inventory_data: Inventory) -> void:
	# First, clear any slots already displayed
	for c in item_container.get_children():
		item_container.remove_child( c )
		c.queue_free()
	
	# Create the slots that need to be displayed
	for slot_data: ItemSlotData in inventory_data.stored_items:
		var slot: ItemSlotUI = item_slot_prefab.instantiate()
		item_container.add_child(slot)
		
		# Subscribe to any relevant events
		# Tell our monitored inventory to connect to the slot clicked events
		slot.slot_clicked.connect( inventory_to_display.on_slot_clicked )
		
		if slot_data != null:
			var slot_index: int = inventory_to_display.stored_items.find( slot_data )
			slot.set_slot_data_with_index( slot_data, slot_index )
