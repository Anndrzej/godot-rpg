extends PanelContainer

class_name InventoryDialog

@export var slot_scene: PackedScene
@onready var grid_container: GridContainer = %GridInventory

var dragged_slot

func _ready() -> void:
	Inv.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_button_pressed():
	hide()

func _on_inventory_updated() -> void:
	clear_grid_container()
	
	for item in Inv.inventory:
		var slot = Inv.slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.drag_start.connect(on_drag_start)
		slot.drag_end.connect(on_drag_end)
		if item != null:
			slot.set_item(item)
		else:
			slot.empty_slot()
		
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func on_drag_start(slot_control: Control):
	var mouse_position = get_global_mouse_position()
	dragged_slot = slot_control
	
func on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null
	
func mage_drag_preview(at_position: Vector2):
	var t = TextureRect.new()
	for slot in grid_container.get_children():
		t.texture = slot.texture_rect.texture
		t.expand_mode = slot.texture_rect.EXPAND_IGNORE_SIZE
		t.stretch_mode = slot.texture_rect.STRETCH_KEEP_ASPECT_CENTERED
		t.custom_minimum_size = slot.texture_rect.size
		t.modulate.a = 0.5
		t.position = Vector2(-at_position)
	add_child(t)

# get the current mouse position in the grid_container's coordinate system
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot: Control) -> int: 
	for i in range(grid_container.get_child_count()):
		# return valid slot
		if grid_container.get_child(i) == slot:
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
		if Inv.swap_inventory_items(slot1_index, slot2_index):
			_on_inventory_updated()
