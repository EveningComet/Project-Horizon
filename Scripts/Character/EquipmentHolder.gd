## Stores the equipment for a combatant.
class_name EquipmentInventory extends Inventory

const MAX_NUMBER_OF_EQUIP_SLOTS: int = 4

## The combatant that will have their stats altered.
var monitored_combatant: Combatant

func _init(com: Combatant):
	monitored_combatant = com
	
	for i in MAX_NUMBER_OF_EQUIP_SLOTS:
		stored_items.insert(i, null)

## Modified version that removes any modifiers from an item, if it exists.
func grab_slot_data(index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	if slot_data != null and slot_data.stored_item != null:
		remove_modifiers_from_equipment( slot_data.stored_item )
	
	# If we have a slot to move, remove the slot and tell anyone caring about the change.
	if slot_data != null and slot_data.stored_item != null:
		stored_items[index] = null
		inventory_updated.emit( self )
		return slot_data
	else:
		return null

## A modified version of the drop slot data method that only accepts equipment
func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	
	# If something wants to place an item in us that is not a weapon, stop it
	if grabbed_slot_data.stored_item.item_type != ItemTypes.ItemTypes.Equipment:
		return grabbed_slot_data
	
	# Prevent armors and weapons from going into the wrong slot
	# 0: Weapons
	# 1-3: Armor/Accessories
	if index < 1 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Weapon:
		return grabbed_slot_data
	elif index > 0 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Accessory:
		return grabbed_slot_data
	
	# Check if we have to remove the previous equipment
	if stored_items[index] != null and stored_items[index].stored_item != null:
		remove_modifiers_from_equipment( stored_items[index].stored_item )
	
	# This is where the equipment will be equipped and then notify the 
	# stats and all that
	add_modifiers_from_equipment( grabbed_slot_data.stored_item )
	
	return super.drop_slot_data( grabbed_slot_data, index )

## A modified version of the drop single slot data method that only accepts equipment
func drop_single_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	
	if grabbed_slot_data.stored_item == null:
		return grabbed_slot_data
	
	# If something wants to place an item in us that is not a weapon, stop it
	if grabbed_slot_data.stored_item.item_type != ItemTypes.ItemTypes.Equipment:
		return grabbed_slot_data
		
	# TODO: Is there a cleaner way to do this?
	# Prevent armors and weapons from going into the wrong slot
	# 0: Weapons
	# 1-3: Armor/Accessories
	if index < 1 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Weapon:
		return grabbed_slot_data
	elif index > 0 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Accessory:
		return grabbed_slot_data
	
	# Check if we have to remove the previous equipment
	if stored_items[index] != null and stored_items[index].stored_item != null:
		remove_modifiers_from_equipment( stored_items[index].stored_item )
	
	# This is where the equipment will be equipped and then notify the 
	# stats and all that
	add_modifiers_from_equipment( grabbed_slot_data.stored_item )
	
	return super.drop_single_slot_data( grabbed_slot_data, index )

func add_modifiers_from_equipment(item_data: ItemData) -> void:
	for sm: StatModifier in item_data.stat_modifiers:
		monitored_combatant.add_modifier(sm.stat_changing, sm)

func remove_modifiers_from_equipment(item_data: ItemData) -> void:
	for sm: StatModifier in item_data.stat_modifiers:
		monitored_combatant.remove_modifier(sm.stat_changing, sm)
