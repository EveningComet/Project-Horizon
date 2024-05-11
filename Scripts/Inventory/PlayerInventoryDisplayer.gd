## A form of the inventory displayer to play better with the player's inventory.
class_name PlayerInventoryDisplayer extends InventoryDisplayer

## Displays the player's money.
@export var money_value_displayer_label: Label

func set_inventory_to_display(inventory_data: Inventory) -> void:
	super(inventory_data)
	inventory_data.money_changed.connect( on_money_changed )
	on_money_changed(inventory_data.money)

func on_money_changed(amount: int) -> void:
	money_value_displayer_label.set_text(str(amount))
