extends PanelContainer

class_name ItemSlot
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

func display(item: Item) -> void:
	if item.qty > 0:
		label.text = str(item.qty)
	texture_rect.texture = item.icon
