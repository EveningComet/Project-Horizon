# TODO: Might be a good idea to have this and party dashboard inherit from a
# base Dashboard class.
## A version of party dashboard that plays well with the shop.
class_name ShopDashboard extends PartyDashboard

@export var shop_inventory_holder: ShopInventoryHolder

func _unhandled_input(event: InputEvent) -> void:
	return

func _ready() -> void:
	shop_inventory_holder.inventory.inventory_interacted.connect(
		on_inventory_interacted
	)
	
	super()
