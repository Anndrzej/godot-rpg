extends Node

signal inventory_updated
signal equipment_updated
signal stats_updated

var slot_scene: PackedScene = preload("res://scenes/ui/inventory/item_slot.tscn")

var inventory: Array = []

var player_node: Node

var _all_recipes: Array[Recipe] = []

var hotbar_size: int = 5
var hotbar_inventory: Array = []

var equipment_slots: Array = []
var equipment_slots_count = equipment_slots.size()
var equipment_control_parent: Array = []
var temp = null
var equipment_types = null
var equipment_name = null

#################### INVENTORY START ####################
func _ready():
	inventory.resize(30)
	equipment_slots.resize(6)
	hotbar_inventory.resize(hotbar_size)
	
func increase_inventory_size() -> void:
	inventory_updated.emit()
	
func set_player(player) -> void:
	player_node = player
	
func add_item(item: Item, to_hotbar = false):
	var added_to_hotbar = false
	
	if to_hotbar:
		added_to_hotbar = add_to_hotbar(item)
		inventory_updated.emit()
	if not added_to_hotbar:
		for i in range(len(inventory)):
			if inventory[i] and inventory[i].name == item.name:
				if inventory[i].name == item.name:
					inventory[i].qty += item.qty
					
					inventory_updated.emit()
					return true
				
		for i in range(len(inventory)):
			if inventory[i] == null:
				inventory[i] = item
				
				inventory_updated.emit()
				
				return true
	return false
	
func remove_item(item: Item) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name and inventory[i].type.effect == item.type.effect:
			inventory[i].qty -= 1
			if inventory[i].qty <= 0:
				inventory[i] = null
			
			inventory_updated.emit()
			return true
			
	return false
	
func swap_inventory_items(index1, index2) -> bool:
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
	
func update_stats(speed_number: Label, power_number: Label) -> void:
	speed_number.text = str(player_node.attack_speed)
	power_number.text = str(player_node.attack_power)
	
#################### INVENTORY END ####################
#################### EQUIPMENT START ####################
func equip_item(item: Item): 
	for i in range(len(equipment_slots)):
		equipment_types = item.type.equipment_type
		equipment_name = item.type.type_names[equipment_types]
		if equipment_control_parent[i].slot_type == equipment_name and item.type is Equipment_Item:
			equipment_slots[i] = item
			increase_player_stats(equipment_slots[i].type)
			
			
	inventory_updated.emit()
	equipment_updated.emit()
	stats_updated.emit()
	
func unequip_item(item: Item):
	for i in range(len(equipment_slots)):
		if equipment_slots[i] != null and equipment_slots[i].name == item.name:
			decrease_player_stats(equipment_slots[i].type)
			equipment_slots[i] = null
			
			equipment_updated.emit()
			inventory_updated.emit()
			stats_updated.emit()
			return true
	
func define_slots_parent(slots):
	equipment_control_parent = slots
	
func check_if_item_is_equipped(item):
	return item in equipment_slots;
	
func decrease_player_stats(stat):
	player_node.attack_power -= stat.item_damage
	
func increase_player_stats(stat):
	player_node.attack_power += stat.item_damage
	
func swap_equipment_items(target_slot, dragged_slot, dragged_slot_index, target_slot_index):
	var equipment_slots_count = equipment_slots.size()
	
	if dragged_slot_index < 0 or dragged_slot_index > equipment_slots_count or target_slot_index < 0 or target_slot_index > equipment_slots_count:
		return false
		
	if target_slot.get_parent().name == 'GridInventory': # if true we dragging from equipment to inventory
		decrease_player_stats(equipment_slots[dragged_slot_index].type)
		
		if equipment_slots[dragged_slot_index] in inventory: # check if i have this item in inventory
			
			inventory[target_slot_index] = null # if i have then just remove it
			equipment_slots[dragged_slot_index] = null
		
		temp = equipment_slots[dragged_slot_index]
		equipment_slots[dragged_slot_index] = inventory[target_slot_index]
		inventory[target_slot_index] = temp
	else:
		if inventory[dragged_slot_index]: # if true we dragging from inventory to equipment
			if inventory[dragged_slot_index].type is Equipment_Item:
				increase_player_stats(inventory[dragged_slot_index].type)
				
				equipment_types = inventory[dragged_slot_index].type.equipment_type
				equipment_name = inventory[dragged_slot_index].type.type_names[equipment_types]
				
				if target_slot.slot_type == equipment_name: # swap specific slots
					temp = inventory[dragged_slot_index]
					equipment_slots[target_slot_index] = temp
				else:
					return
				
			else:
				return false
			
		else: # if not we dragging thru the equipment
			equipment_types = equipment_slots[dragged_slot_index].type.equipment_type
			equipment_name = equipment_slots[dragged_slot_index].type.type_names[equipment_types]
			
			if target_slot.slot_type == equipment_name: # swap specifi slots
				temp = equipment_slots[dragged_slot_index]
				equipment_slots[dragged_slot_index] = equipment_slots[target_slot_index]
				equipment_slots[target_slot_index] = temp
			else: 
				return
	
	inventory_updated.emit()
	equipment_updated.emit()
	stats_updated.emit()
	return true
##################### EQUIPMENT END ####################
##################### CRAFTING START ####################
func add_craft_item(item: Item) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name:
			if item.type is Consumable_Item:
				inventory[i].qty += item.type.ingredients_qty
			else:
				inventory[i].qty += 1
				
			inventory_updated.emit()
			return true
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			if item.type is Consumable_Item:
				inventory[i].qty = item.type.ingredients_qty
			else: 
				inventory[i].qty = item.qty
				
			inventory_updated.emit()
			
			return true
			
	return false
	
func craft_item(item: Item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name:
			inventory[i].qty -= item.type.ingredients_qty
			inventory_updated.emit()
			return true
			
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			
			inventory_updated.emit()
			
			return true
	
	
func has_all(items: Array[Item]) -> bool:
	var needed: Array[Item] = items.duplicate()
	var to_remove: Array[Item] = []
	var found_all = true
	
	for needed_item in needed:
		var found = false
		for available in inventory:
			if available and needed_item.name == available.name:
				found = true
				to_remove.append(needed_item)
		if not found:
			found_all = false
	if not found_all:
		return false
		
	for item in needed:
		if item.qty >= item.type.ingredients_qty:
			to_remove.erase(item)
			
	return to_remove.is_empty()
	
#################### CRAFTING END ####################
#################### HOTBAR START ####################

func add_to_hotbar(item: Item): 
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false

func remove_hotbar_item(item: Item):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i].name == item.name:
			if hotbar_inventory[i].qty <= 0:
				print('remove')
				hotbar_inventory[i] = null
				inventory_updated.emit()
				return true
		return false
		
func unassign_hotbar_item(item: Item) -> bool:
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i].name == item.name:
				hotbar_inventory[i] = null
				inventory_updated.emit()
				return true
	return false
		
func check_if_item_is_assigned(item):
	return item in hotbar_inventory;
	
	
func swap_hotbar_items(index1, index2) -> bool:
	if index1 < 0 or index1 > hotbar_inventory.size() or index2 < 0 or index2 > hotbar_inventory.size():
		return false
	var temp = hotbar_inventory[index1]
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	inventory_updated.emit()
	return true
#################### HOTBAR END ####################
