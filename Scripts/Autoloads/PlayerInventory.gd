## The player's inventory.
extends Node

var inventory: Inventory = Inventory.new()

var starting_money_on_new_game: int = 100

func does_player_have_enough_money_for_item(item_data: ItemData) -> bool:
	return inventory.money >= item_data.cost
