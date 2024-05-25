extends StaticBody2D

class_name ResourceNode

@export var starting_resources: int = 1
var current_resources: int

func _ready() -> void:
	current_resources = starting_resources

func harvest(amount: int) -> void:
	current_resources -= amount
