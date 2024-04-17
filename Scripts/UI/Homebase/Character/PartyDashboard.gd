## Displays the player's current inventory. In addtion
extends Control

## The node displaying the inventory.
@export var player_inventory_ui: InventoryDisplayer

## The node storing the character information.
@export var character_inspection_window: CharacterInspectionWindow

var player_inventory: Inventory

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible

func _ready() -> void:
	hide()
	if PlayerPartyController.has_members() == false:
		character_inspection_window.hide()
	else:
		character_inspection_window.current_character = PlayerPartyController.party_members[0]
	
	# Test adding an item
	var slot_data: ItemSlotData = ItemSlotData.new()
	slot_data.stored_item = load("res://Game Data/Items/Cool Hat.tres")
	slot_data.quantity    = 1
	PlayerInventory.add_slot_data(slot_data)
	
	# Set the player inventory
	set_player_inventory(PlayerInventory)
	
func set_player_inventory(inventory_data: Inventory) -> void:
	player_inventory = inventory_data
	player_inventory_ui.set_inventory_to_display( player_inventory )

func on_inventory_interacted(inventory_data: Inventory) -> void:
	pass
