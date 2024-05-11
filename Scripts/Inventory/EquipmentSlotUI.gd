## Represents a character's equipment.
class_name EquipmentSlotUI extends ItemSlotUI

## The allowed type of equipment this slot accepts.
@export var equipment_type: ItemTypes.EquipmentTypes = ItemTypes.EquipmentTypes.Accessory

## Reference to the current character's equipment holder. Allows easy access
## to their equipment.
var char_equipment: EquipmentInventory

