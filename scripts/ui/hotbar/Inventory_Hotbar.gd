extends Control

@onready var hotbar_container = %HotbarContainer

var dragged_slot

func _ready():
	Inv.inventory_updated.connect(_on_update_hotbar_ui)
	_on_update_hotbar_ui()

func _on_update_hotbar_ui():
	clear_hotbar_container()
	
	for i in range(Inv.hotbar_size):
		var slot = Inv.slot_scene.instantiate()
		slot.set_item_index(i)
		
		slot.drag_start.connect(on_drag_start)
		slot.drag_end.connect(on_drag_end)
		
		hotbar_container.add_child(slot)
		
		if Inv.hotbar_inventory[i] != null:
			slot.set_item(Inv.hotbar_inventory[i])
		else:
			slot.empty_slot()
		slot.update_assignment_status()
		
	
func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
	
func on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("dragged started for slot ", dragged_slot)
	
func on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null

# get the current mouse position in the grid_container's coordinate system
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot: Control) -> int: 
	for i in range(hotbar_container.get_child_count()):
		# return valid slot
		if hotbar_container.get_child(i) == slot:
			return i
	# return invalid slot
	return -1
	
func drop_slot(slot1, slot2):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	
	if slot1_index == -1 or slot2_index == -1:
		print("Invalid slot index")
		return
	else:
		if Inv.swap_hotbar_items(slot1_index, slot2_index):
			_on_update_hotbar_ui()
