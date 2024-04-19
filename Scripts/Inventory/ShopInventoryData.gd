## Modified version of inventory to work better with shops.
class_name ShopInventoryData extends Inventory

# TODO: Modify the original methods to not permanently remove items from
# the shop.
## Modified version that returns a copy of the slot data. It does not remove
## the item from this inventory.
func grab_slot_data(index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	# If we have a slot to move, remove the slot and tell anyone caring about the change.
	if slot_data != null and slot_data.stored_item != null:
		inventory_updated.emit( self )
		return slot_data
	else:
		return null
