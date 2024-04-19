## Controls the scene for buying items and equipment.
class_name AcquisitionMenuController extends Node

@export_file("*.tscn") var homebase_menu_scene: String

## Stores the main buttons of the scene.
@export var main_buttons_container: Control

## The button the player clicks on for buying and selling items/equipment.
@export var deal_button:   Button

## Takes the player back to the main menu of the homebase.
@export var return_button: Button

## Middleman for interacting between the shop, the player's inventory,
## and the player's party.
@export var shop_dashboard: ShopDashboard

## The object that displays the contents of the shop.
@export var shop_inventory_displayer: ShopInventoryDisplayer

## Node storing the inventory data of the shop.
@export var shop_inventory_data: ShopInventoryHolder

var player_inventory: Inventory

func _unhandled_input(event: InputEvent) -> void:
	# Maybe this class should be a state machine.
	if event.is_action_pressed("ui_cancel") and shop_inventory_displayer.visible == true:
		shop_inventory_displayer.hide()
		shop_dashboard.hide()
		main_buttons_container.show()
		main_buttons_container.get_child(0).grab_focus()

func _ready() -> void:
	player_inventory = PlayerInventory.inventory
	
	shop_inventory_displayer.set_inventory_to_display( shop_inventory_data.inventory )
	
	deal_button.button_down.connect( on_deal_button_pressed )
	return_button.button_down.connect( on_return_button_pressed )
	main_buttons_container.get_child(0).grab_focus()

func on_deal_button_pressed() -> void:
	main_buttons_container.hide()
	shop_dashboard.show()
	shop_inventory_displayer.show()

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_menu_scene )
