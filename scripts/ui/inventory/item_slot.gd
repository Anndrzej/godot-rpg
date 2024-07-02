extends Control

class_name ItemSlot

@onready var texture_rect: TextureRect = %TextureRect
@onready var item_qty: Label = %ItemQty
@onready var details_panel = %DetailsPanel
@onready var item_name = %ItemName
@onready var item_type = %ItemType
@onready var item_description = %ItemDescription
@onready var usage_panel = %UsagePanel
@onready var assign_button = %AssignButton

@export var item_data: Item

var slot_index: int = -1
var is_assigned: bool = false
var draggable: bool = false
var is_texture_created = false
var t : TextureRect = TextureRect.new()


signal drag_start(slot)
signal drag_end()

func empty_slot():
	texture_rect.texture = null
	item_qty.text = ""
	
	

func set_item(item: Item) -> void:
	item_data = item
	if item_data.qty > 0:
		item_qty.text = str(item_data.qty)
		
	item_name.text = str(item_data.name)
	
	if item_data.type is Equipment_Item:
		item_type.text = str(item_data.type.type)
	elif item_data.type is Craft_Item:
		item_type.text = str(item_data.qty)
	texture_rect.texture = item_data.icon
	
	update_assignment_status()

func set_item_index(set_index):
	slot_index = set_index

func _on_item_button_mouse_entered():
	if item_data != null:
		usage_panel.visible = false
		details_panel.visible = true
		
		
func _on_item_button_mouse_exited():
	details_panel.visible = false

func _on_use_button_pressed():
	usage_panel.visible = false
	if item_data != null and item_data.effect:
		if Inv.player_node:
			Inv.player_node.apply_item_effect(item_data)
			Inv.remove_item(item_data)
		else:
			print('error, cant find player')

func update_assignment_status():
	is_assigned = Inv.check_if_item_is_assigned(item_data)
	
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"

func _on_assign_button_pressed():
	if item_data != null:
		if is_assigned:
			Inv.unassign_hotbar_item(item_data)
			is_assigned = false
		else:
			Inv.add_item(item_data, true)
			is_assigned = true
		update_assignment_status()

func _process(delta):
	if draggable:
		make_drag_preview()
	else:
		t.texture = null

func make_drag_preview():
	if !is_texture_created or t.texture == null:
		t.texture = texture_rect.texture
		t.expand_mode = texture_rect.EXPAND_IGNORE_SIZE
		t.stretch_mode = texture_rect.STRETCH_KEEP_ASPECT_CENTERED
		t.custom_minimum_size = texture_rect.size
		t.modulate.a = 0.5
		add_child(t)
		
	t.position = Vector2(get_local_mouse_position())

	# Устанавливаем флаг, что TextureRect создан
	is_texture_created = true
func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				draggable = true
				drag_start.emit(self)
			else:
				draggable = false
				drag_end.emit()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if item_data != null:
				usage_panel.visible = !usage_panel.visible
