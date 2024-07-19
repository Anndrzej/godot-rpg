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
@onready var equip_button = %EquipButton
@onready var drop_button = %DropButton
@onready var use_button = %UseButton
@onready var active_item = $ActiveItem
@onready var item_button = %ItemButton

@export var item_data: Item

@export var slot_type: String

var slot_index: int = -1
var is_assigned: bool = false
var is_equipped: bool = false
var draggable: bool = false
var is_texture_created = false
var t : TextureRect = TextureRect.new()

signal drag_start(slot)
signal drag_end()

func _ready():
	if get_parent().name == 'PlayerEquipmentControl' or get_parent().name == 'HotbarContainer':
		usage_panel.queue_free()

func empty_slot():
	texture_rect.texture = null
	item_qty.text = ""
	
func set_item(item: Item) -> void:
	item_data = item
	if item_data.qty > 0:
		item_qty.text = str(item_data.qty)
		
	item_name.text = str(item_data.name)
	
	if item_data.type is Equipment_Item:
		item_type.text = str(item_data.type.equipment_type)
	elif item_data.type is Consumable_Item:
		item_type.text = str(item_data.qty)
	texture_rect.texture = item_data.icon
	
	update_assignment_status()
	update_equipment_status()
	
func set_item_index(set_index):
	slot_index = set_index
	
func _on_item_button_mouse_entered():
	if item_data != null and usage_panel != null:
		usage_panel.visible = false
		details_panel.visible = true
		
func _on_item_button_mouse_exited():
	details_panel.visible = false
	
func _on_use_button_pressed():
	usage_panel.visible = false
	if item_data != null and item_data.type.effect:
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
	elif is_texture_created:
		is_texture_created = false
		remove_child(t)
	
func make_drag_preview():
	if !is_texture_created or t.texture == null:
		t.texture = texture_rect.texture
		t.expand_mode = texture_rect.EXPAND_IGNORE_SIZE
		t.stretch_mode = texture_rect.STRETCH_KEEP_ASPECT_CENTERED
		t.custom_minimum_size = texture_rect.size
		t.modulate.a = 0.5
		add_child(t)
		
	t.position = Vector2(get_local_mouse_position())
	
	is_texture_created = true
	
func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.is_pressed():
				if event.is_double_click() and item_data.type is Equipment_Item:
					if is_equipped:
						Inv.unequip_item(item_data)
					else:
						Inv.equip_item(item_data)
				draggable = true
				drag_start.emit(self)
			else:
				draggable = false
				drag_end.emit()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if item_data != null and usage_panel != null:
				usage_panel.visible = !usage_panel.visible
				usage_panel.position.x = position.x + 50
				usage_panel.position.y = position.y + 100
				
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), size).has_point(evLocal.position):
			item_button.release_focus()
	
func _on_equip_button_pressed():
	if item_data != null and item_data.type is Equipment_Item:
		if is_equipped:
			Inv.unequip_item(item_data)
			is_equipped = false
		else:
			Inv.equip_item(item_data)
			is_equipped = true
		update_equipment_status()
	else:
		return
	
func update_equipment_status():
	is_equipped = Inv.check_if_item_is_equipped(item_data)
	if is_equipped:
		equip_button.text = "Unequip"
		active_item.visible = true
	else:
		equip_button.text = "Equip"
		active_item.visible = false
		
