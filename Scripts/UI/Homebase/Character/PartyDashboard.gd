## This menu deals with displaying the player's current inventory, the stats
## of a particular character, that character's equipment. Another way to think
## of this is as the "middleman" between those previously mentioned aspects.
class_name PartyDashboard extends Control

## The node displaying the inventory.
@export var player_inventory_ui: PlayerInventoryDisplayer

## The node storing the character information.
@export var character_inspection_window: CharacterInspectionWindow

## Used for displaying a dragged item to the player.
@export var grabbed_slot_ui: ItemSlotUI
var grabbed_slot_data: ItemSlotData

var player_inventory: Inventory

var currently_displayed_character: PlayerCombatant = null

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
	
	# Set the player inventory
	set_player_inventory(PlayerInventory.inventory)
	
	# Sub to the character changed event
	character_inspection_window.displayed_character_changed.connect(
		on_displayed_party_member_changed
	)
	on_displayed_party_member_changed( character_inspection_window.current_character )
	
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

## When the player switches the character currently being displayed, change
## the active interactable equipment.
func on_displayed_party_member_changed(new_pm_to_display: PlayerCombatant) -> void:
	if currently_displayed_character != null:
		currently_displayed_character.equipment_holder.inventory_interacted.disconnect(
			on_inventory_interacted
		)
	
	if new_pm_to_display != null:
		currently_displayed_character = new_pm_to_display
		currently_displayed_character.equipment_holder.inventory_interacted.connect(
			on_inventory_interacted
		)

## Used to transfer items between inventories and equipment.
func on_inventory_interacted(inventory_data: Inventory, index: int, button: int) -> void:
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
