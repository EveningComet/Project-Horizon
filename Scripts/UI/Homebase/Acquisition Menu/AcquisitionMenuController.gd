## Controls the scene for buying items and equipment.
class_name AcquisitionMenuController extends Node

@export_file("*.tscn") var homebase_menu_scene: String

## Stores the main buttons of the scene.
@export var main_buttons_container: Control

## The button the player clicks on for buying and selling items/equipment.
@export var deal_button:   Button

## Takes the player back to the main menu of the homebase.
@export var return_button: Button

## The object that displays the contents of the shop.
@export var shop_inventory_displayer: ShopInventoryDisplayer

## Node storing the inventory data of the shop.
@export var shop_inventory_data: ShopInventoryHolder

func _ready() -> void:
	shop_inventory_displayer.set_inventory_to_display( shop_inventory_data.inventory )
	
	deal_button.button_down.connect( on_deal_button_pressed )
	return_button.button_down.connect( on_return_button_pressed )
	main_buttons_container.get_child(0).grab_focus()

func on_deal_button_pressed() -> void:
	pass

func on_return_button_pressed() -> void:
	SceneController.switch_to_scene( homebase_menu_scene )
