extends PanelContainer

class_name InventoryDialog

@export var slot_scene: PackedScene
@onready var grid_container: IngredientsGrid = %GridIngredients

func open(inventory: Inventory) -> void:
	show()
	
	grid_container.displayIngredients(inventory.get_items())

func _on_button_pressed():
	hide()

func close() -> void:
	hide()
