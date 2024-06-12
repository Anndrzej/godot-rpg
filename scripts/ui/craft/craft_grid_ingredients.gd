class_name CraftIngredientsGrid
extends GridContainer

@export var slot_scene: PackedScene

func displayIngredients(items: Array[Item]) -> void:
	show()
	
	for child in get_children():
		child.queue_free()
	
	for item in items:
		var slot = slot_scene.instantiate()
		add_child(slot)
		slot.display(item)
