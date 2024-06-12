extends Node

class_name GameInputEvents

static func movement_input() -> Vector2:
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	return direction

static func attack_input() -> bool:
	if Input.is_action_just_pressed("attack"):
		return true
	else: 
		return false

static func interract_input() -> bool:
	if Input.is_action_pressed("interract"):
		return true
	else:
		return false

static func inventory_input() -> bool:
	if Input.is_action_pressed("inventory"):
		return true
	else:
		return false


static func crafting_input() -> bool:
	if Input.is_action_pressed("crafting"):
		return true
	else:
		return false
