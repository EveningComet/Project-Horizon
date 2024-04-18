## Represents a character's equipment.
class_name EquipmentSlotUI extends ItemSlotUI

## The allowed type of equipment this slot accepts.
@export var equipment_type: ItemTypes.EquipmentTypes = ItemTypes.EquipmentTypes.Accessory

## The piece of equipment this slot is storing.
var stored_equipment: ItemData

## Reference to the current character's equipment holder. Allows easy access
## to their equipment.
var char_equipment: EquipmentInventory
