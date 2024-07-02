extends Node

signal inventory_updated

var slot_scene: PackedScene = preload("res://scenes/ui/inventory/item_slot.tscn")

var inventory: Array = []
var player_node: Node
var _all_recipes: Array[Recipe] = []

var hotbar_size: int = 5
var hotbar_inventory: Array = []

func _ready():
	inventory.resize(30)
	hotbar_inventory.resize(hotbar_size)

func add_item(item: Item, to_hotbar = false):
	var added_to_hotbar = false
	
	if to_hotbar:
		added_to_hotbar = add_to_hotbar(item)
		inventory_updated.emit()
	if not added_to_hotbar:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i].name == item.name:
				inventory[i].qty += item.qty
				inventory_updated.emit()
				return true
				
			elif inventory[i] == null:
				inventory[i] = item
				
				inventory_updated.emit()
				
				return true
				
		return false
	
func remove_item(item: Item) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name and inventory[i].effect == item.effect:
			inventory[i].qty -= 1
			if inventory[i].qty <= 0:
				inventory[i] = null
			
			inventory_updated.emit()
			return true
			
	return false
	
func increase_inventory_size() -> void:
	inventory_updated.emit()

func set_player(player) -> void:
	player_node = player
	
func swap_inventory_items(index1, index2) -> bool:
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
##################### CRAFTING ####################
func add_craft_item(item: Item) -> bool:
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name:
			inventory[i].qty += item.type.ingredients_qty
			inventory_updated.emit()
			return true
			
		elif inventory[i] == null:
			inventory[i] = item
			inventory[i].qty = item.type.ingredients_qty
			inventory_updated.emit()
			
			return true
			
	return false
	
func craft_item(item: Item):
	if item.type is Craft_Item:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i].name == item.name:
				inventory[i].qty -= item.type.ingredients_qty
				inventory_updated.emit()
				return true
				
			elif inventory[i] == null:
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


############## HOTBAR #################

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
		
func unassign_hotbar_item(item: Item):
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
