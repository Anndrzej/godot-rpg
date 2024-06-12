extends Resource
class_name Equipment


enum Type {HEAD, CHEST, LEGS, WEAPON}

@export var type: Type
@export var item_name: String
@export var item_damage: int
@export var item_defence: int
@export_multiline var description: String
@export var item_texture: Texture2D
