extends Resource

class_name Recipe

@export var name: String
@export var ingredients: Array[Item] = []
@export var results: Array[Item] = []
@export var scene: PackedScene
@export var icon: Texture2D
@export var category: String
