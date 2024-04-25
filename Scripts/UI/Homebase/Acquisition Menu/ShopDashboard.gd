# TODO: Might be a good idea to have this and party dashboard inherit from a
# base Dashboard class.
## A version of party dashboard that plays well with the shop.
class_name ShopDashboard extends PartyDashboard

@export var shop_inventory_holder: ShopInventoryHolder

## A referece to the shop's inventory UI. This is used to assist with selling
## items.
@export var shop_inventory_displayer: InventoryDisplayer

func _unhandled_input(event: InputEvent) -> void:
	return

func _ready() -> void:
	shop_inventory_holder.inventory.inventory_interacted.connect(
		on_shop_inventory_interacted
	)
	shop_inventory_displayer.gui_input.connect( on_shop_gui_input )
	super()

## When the player clicks over the shop, sell the item.
func on_shop_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and grabbed_slot_data != null:
		player_inventory.add_money( grabbed_slot_data.stored_item.cost )
		grabbed_slot_data = null
		update_grabbed_slot()
	elif event.is_action_pressed("right_click") and grabbed_slot_data != null:
		player_inventory.add_money(grabbed_slot_data.stored_item.cost)
		grabbed_slot_data.quantity -= 1
		if grabbed_slot_data.quantity < 1:
			grabbed_slot_data = null
		update_grabbed_slot()

func on_shop_inventory_interacted(inventory_data: ShopInventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:
		
		[null, MOUSE_BUTTON_LEFT]:
			if PlayerInventory.does_player_have_enough_money_for_item(
				inventory_data.stored_items[index].stored_item
			) == false:
				return
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		
		[_, MOUSE_BUTTON_LEFT]:
			# Sell the item when the player clicks over a slot
			player_inventory.add_money( grabbed_slot_data.stored_item.cost )
			grabbed_slot_data = null
		
		[null, MOUSE_BUTTON_RIGHT]:
			if PlayerInventory.does_player_have_enough_money_for_item(
				inventory_data.stored_items[index].stored_item
			) == false:
				return
			
			# Add the item to the player's inventory immediately
			player_inventory.add_slot_data(
				inventory_data.grab_slot_data(index)
			)
		
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()
