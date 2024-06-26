## Displays the data of an inventory object to the player.
class_name InventoryDisplayer extends Control

## The inventory that will be shown.
@export var inventory_to_display: Inventory

## Template of the visual representation of an item in an inventory.
@export var item_slot_prefab: PackedScene

## Stores where the visual objects will be displayed.
@export var item_container: GridContainer

## Used as an easy way to display stat changes for a character the player
## is inspecting.
var character_inspection_window: CharacterInspectionWindow

func set_inventory_to_display(inventory_data: Inventory) -> void:
	if inventory_to_display != null:
		inventory_to_display.inventory_updated.disconnect( populate_items )
	
	inventory_to_display = inventory_data
	inventory_to_display.inventory_updated.connect( populate_items )
	populate_items( inventory_to_display )

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
			set_slot_data(slot, slot_data)

func set_character_inspection_window(char_inspector: CharacterInspectionWindow) -> void:
	character_inspection_window = char_inspector

func set_slot_data(slot: ItemSlotUI, slot_data: ItemSlotData) -> void:
	slot.set_slot_data( slot_data )
	slot.set_char_inspection_window( character_inspection_window )
