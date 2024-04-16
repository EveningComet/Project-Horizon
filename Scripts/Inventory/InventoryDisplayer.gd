## Displays the data of an inventory object to the player.
class_name InventoryDisplayer extends Control

## The inventory that will be shown.
@export var inventory_to_display: Inventory

## Template of the visual representation of an item in an inventory.
@export var item_slot_prefab: PackedScene

## Stores where the visual objects will be displayed.
@export var item_container: GridContainer

func set_inventory_to_display(inventory_data: Inventory) -> void:
	inventory_to_display = inventory_data
	inventory_to_display.inventory_updated.connect( populate_item_grid )
	populate_item_grid( inventory_to_display )

## Handles updating the display of the inventory.
func populate_item_grid(inventory_data: Inventory) -> void:
	for c in item_container.get_children():
		item_container.remove_child( c )
		c.queue_free()
	
	# Create the slots that need to be displayed
	for slot_data in inventory_data.stored_items:
		pass
