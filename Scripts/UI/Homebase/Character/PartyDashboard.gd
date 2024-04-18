## This menu deals with displaying the player's current inventory, the stats
## of a particular character, that character's equipment.
class_name PartyDashboard extends Control

## The node displaying the inventory.
@export var player_inventory_ui: InventoryDisplayer

## The node storing the character information.
@export var character_inspection_window: CharacterInspectionWindow

## Used for displaying a dragged item to the player.
@export var grabbed_slot_ui: ItemSlotUI
var grabbed_slot_data: ItemSlotData

var player_inventory: Inventory

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible

func _input(event: InputEvent) -> void:
	if grabbed_slot_ui.visible == true:
		# Display the grabbed slot at the mouse position with an offset
		grabbed_slot_ui.global_position = get_global_mouse_position() + Vector2(5, 5)

func _ready() -> void:
	hide()
	visibility_changed.connect( on_visibility_changed )
	
	# Test adding an item
	var slot_data: ItemSlotData = ItemSlotData.new()
	slot_data.stored_item = load("res://Game Data/Items/Cool Hat.tres")
	slot_data.quantity    = 1
	PlayerInventory.inventory.add_slot_data(slot_data)
	
	# Set the player inventory
	set_player_inventory(PlayerInventory.inventory)
	
	# TODO: Proper handling of setting the equipment.
	if PlayerPartyController.has_members() == false:
		character_inspection_window.hide()
	else:
		character_inspection_window.current_character = PlayerPartyController.party_members[0]
		character_inspection_window.current_character.equipment_holder.inventory_interacted.connect(
			on_inventory_interacted
		)
	
func set_player_inventory(inventory_data: Inventory) -> void:
	player_inventory = inventory_data
	player_inventory.inventory_interacted.connect( on_inventory_interacted )
	player_inventory_ui.set_inventory_to_display( player_inventory )

	# Connect to the gui input of the inventory displayer so that clicking
	# over it with a held item will drop it there
	player_inventory_ui.gui_input.connect( on_player_inventory_displayer_selected )

func on_visibility_changed() -> void:
	# Prevent the potential loss of items
	if visible == false and grabbed_slot_data != null:
		player_inventory.add_slot_data( grabbed_slot_data )
		grabbed_slot_data = null
		update_grabbed_slot()
	
func on_player_inventory_displayer_selected(event: InputEvent) -> void:
	if grabbed_slot_data != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			player_inventory.add_slot_data( grabbed_slot_data )
			grabbed_slot_data = null
			update_grabbed_slot()

func on_inventory_interacted(inventory_data: Inventory, index: int, button: int) -> void:
	if OS.is_debug_build() == true:
		print("PartyDashboard :: Interacting with inventory: ", inventory_data)
	
	match [grabbed_slot_data, button]:
		
		# The player wants to grab the whole item
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		
		# The player wants to drop the item in a new slot
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		
		# Attempt to use the item
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data( index )
		
		# Player is trying to drop a piece of the slot
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
		
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data != null:
		grabbed_slot_ui.global_position = get_global_mouse_position()
		grabbed_slot_ui.show()
		grabbed_slot_ui.set_slot_data( grabbed_slot_data)
	else:
		grabbed_slot_ui.hide()
