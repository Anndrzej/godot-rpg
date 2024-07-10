extends Control

class_name InventoryDialog

@export var slot_scene: PackedScene
@onready var grid_container: GridContainer = %GridInventory
@onready var player_equipment: Control = %PlayerEquipmentControl
@onready var speed_number = %SpeedNumber
@onready var power_number = %PowerNumber
@onready var player_stats_container = %PlayerStatsContainer

var dragged_slot
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	speed_number.text = str(player.attack_speed)
	power_number.text = str(player.attack_power)
	
	Inv.inventory_updated.connect(_on_inventory_updated)
	Inv.equipment_updated.connect(_on_equipment_updated)
	Inv.stats_updated.connect(_on_stats_updated)
	
	_on_inventory_updated()
	_on_equipment_updated()
	_on_stats_updated()

func _on_button_pressed():
	hide()

func _on_stats_updated() -> void:
	speed_number.text = str(player.attack_speed)
	power_number.text = str(player.attack_power)
	
func _on_inventory_updated() -> void:
	clear_grid_container()
	
	for item in Inv.inventory:
		var slot = Inv.slot_scene.instantiate()
		
		grid_container.add_child(slot)
		
		slot.drag_start.connect(on_drag_start)
		slot.drag_end.connect(on_drag_end)
		
		if item != null and item is Item:
			slot.set_item(item)
		else:
			slot.empty_slot()
			
func _on_equipment_updated() -> void:
	var slots_eq = player_equipment.get_children()
	var slots = []
	clear_equipment_container()
	# create empty slots for equipment
	for i in range(len(Inv.equipment_slots)):
		var slot = Inv.slot_scene.instantiate()
		
		slot.position.x = slots_eq[i].position.x
		slot.position.y = slots_eq[i].position.y
		slot.slot_type = slots_eq[i].slot_type
		
		slot.drag_start.connect(on_drag_start)
		slot.drag_end.connect(on_drag_end)
		
		player_equipment.add_child(slot)
		
		slots.append(slot)
	# add item when specific slot based on Inv.equipment_slots index
	for i in range(len(slots)):
		Inv.define_slots_parent(slots)
		if i < len(Inv.equipment_slots) and Inv.equipment_slots[i] != null:
			slots[i].set_item(Inv.equipment_slots[i])
			
			Inv.update_stats(speed_number, power_number)
		else:
			slots[i].empty_slot()
		
		
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
	
func clear_equipment_container():
	while player_equipment.get_child_count() > 0:
		var child = player_equipment.get_child(0)
		player_equipment.remove_child(child)
		child.queue_free()
	
func on_drag_start(slot_control: Control):
	var mouse_position = get_global_mouse_position()
	dragged_slot = slot_control
	
func on_drag_end():
	var target_slot = get_slot_under_mouse()
	
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null
	
# get the current mouse position in the grid_container's coordinate system
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
			
	for slot in player_equipment.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot: Control) -> int: 
	for i in range(grid_container.get_child_count()):
		# return valid slot
		if grid_container.get_child(i) == slot:
			return i
			
	for i in range(player_equipment.get_child_count()):
		# return valid slot
		if player_equipment.get_child(i) == slot:
			return i
	# return invalid slot
	return -1
	
func drop_slot(dragged_slot, target_slot):
	var dragged_slot_index = get_slot_index(dragged_slot)
	var target_slot_index = get_slot_index(target_slot)
	if dragged_slot_index == -1 or target_slot_index == -1:
		print("Invalid slot index")
		return
	else:
		if target_slot.get_parent() == player_equipment or dragged_slot.get_parent() == player_equipment:
			if Inv.swap_equipment_items(target_slot, dragged_slot, dragged_slot_index, target_slot_index):
				_on_inventory_updated()
		else:
			if Inv.swap_inventory_items(dragged_slot_index, target_slot_index):
				_on_inventory_updated()
