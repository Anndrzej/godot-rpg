extends Node2D

class_name Collect

@export var item: Item
@export var qty: int
func _ready():
	var instance = item.scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body):
	if body.has_method('collect'):
		item.qty += qty
		body.collect(item)
		queue_free()
