## Represents an item in an inventory.
class_name ItemSlotUI extends PanelContainer

## Fired when the player clicks on this slot to allow adding/removing items
signal slot_clicked(index: int, button: int)

## The visual of the item that will be displayed.
@export var icon: TextureRect

## Visualizes the quantity of the item to the player.
@export var amount_label: Label

## Used to help with sorting items.
var index: int = -1

var item: ItemData

func _ready() -> void:
	gui_input.connect( on_gui_input )
	mouse_entered.connect( on_mouse_over )
	mouse_exited.connect( on_mouse_exit )

func set_slot_data(slot_data: ItemSlotData) -> void:
	if slot_data == null:
		icon.set_texture(null)
		return
	
	item = slot_data.stored_item
	icon.set_texture( item.image )
	
	update_quantity_text( slot_data )

func set_slot_data_with_index(slot_data: ItemSlotData, new_index: int) -> void:
	if slot_data == null:
		icon.set_texture(null)
		return
	
	index = new_index
	item  = slot_data.stored_item
	icon.set_texture( item.image )
	
	update_quantity_text( slot_data )

func update_quantity_text(slot_data: ItemSlotData) -> void:
	if slot_data.quantity > 1:
		amount_label.set_text( str(slot_data.quantity) )
		amount_label.show()
	else:
		amount_label.set_text( str(1) )
		amount_label.hide()

func on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			slot_clicked.emit(
				index if index > -1 else get_index(), event.button_index
			) 

func on_focused() -> void:
	pass

func on_focus_exited() -> void:
	pass

func on_mouse_over() -> void:
	if item != null:
		EventBus.on_tooltip_needed(self)

func on_mouse_exit() -> void:
	EventBus.tooltip_hide.emit()
