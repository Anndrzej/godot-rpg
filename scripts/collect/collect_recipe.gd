extends Node2D

class_name CollectRecipe

@export var recipe: Recipe

func _ready():
	if recipe and recipe.scene:
		var instance = recipe.scene.instantiate()
		add_child(instance)

func _on_area_2d_body_entered(body):
	if body.has_method('collect_recipe'):
		body.collect_recipe(recipe)
		queue_free()
		
