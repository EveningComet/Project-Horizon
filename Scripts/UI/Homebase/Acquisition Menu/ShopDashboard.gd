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
		on_inventory_interacted
	)
	shop_inventory_displayer.gui_input.connect( on_shop_gui_input )
	super()

## When the player clicks over the shop, sell the item.
func on_shop_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and grabbed_slot_data != null:
		player_inventory.add_money( grabbed_slot_data.stored_item.cost )
		grabbed_slot_data = null
		update_grabbed_slot()

func on_inventory_interacted(inventory_data: Inventory, index: int, button: int) -> void:
	if inventory_data is Inventory:
		super(inventory_data, index, button)
	
	# TODO: When the player has a grabbed slot, and they click on a slot in the
	# shop, the player should sell what they currently have held.
	#elif inventory_data is ShopInventoryData:
		#if OS.is_debug_build() == true:
			#print("ShopDashboard :: The player clicked over a shop node.")
		#pass
