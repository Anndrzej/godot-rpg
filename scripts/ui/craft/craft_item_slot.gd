extends PanelContainer

class_name CraftItemSlot
@onready var texture_rect: TextureRect = %TextureRect
@onready var needed_label: Label = %NeededLabel
@onready var have_label: Label = %HaveLabel


func display(item: Item) -> void:
	var grid_results_name = get_parent()
	have_label.text = str(item.qty)
	
	if item.type is Consumable_Item and item.type.ingredients_qty > 0:
		needed_label.text = str(item.type.ingredients_qty)
	if item.qty <= 0 || grid_results_name.name == "GridResult":
		needed_label.hide()
		have_label.hide()
	
	if item.type is Consumable_Item && item.qty >= item.type.ingredients_qty:
		needed_label.set("theme_override_colors/font_color", Color(0,0,255))
		have_label.set("theme_override_colors/font_color", Color(0,0,255))
		
	texture_rect.texture = item.icon
