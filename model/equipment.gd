extends Resource
class_name Equipment_Item

enum Type {HEAD, CHEST, LEGS, LEFT_HAND, RIGHT_HAND, MAIN}

var type_names = {
	Type.HEAD: "head",
	Type.CHEST: "chest",
	Type.LEGS: "legs",
	Type.LEFT_HAND: "left hand",
	Type.RIGHT_HAND: "right hand",
	Type.MAIN: "main"
}

@export var equipment_type: Type
@export var item_damage: int
@export var item_defence: int
