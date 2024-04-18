## Alternative version meant to play nice with inventories.
class_name EquipmentDisplayer extends InventoryDisplayer

func set_inventory_to_display(inventory_data: Inventory) -> void:
	if inventory_to_display != null:
		for i in inventory_data.stored_items.size():
			var slot = item_container.get_child(i)
			slot.slot_clicked.disconnect( inventory_to_display.on_slot_clicked )
			
	super( inventory_data )
	
	for i in inventory_data.stored_items.size():
		var slot = item_container.get_child(i)
		slot.slot_clicked.connect( inventory_to_display.on_slot_clicked )

## Changed method to make it play nicer with equipment inventories.
func populate_items(inventory_data: Inventory) -> void:
	for i in inventory_data.stored_items.size():
		var slot: ItemSlotData = inventory_data.stored_items[i]
		item_container.get_child(i).set_slot_data( slot )
