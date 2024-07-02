extends Node

class_name GameInputEvents

static func movement_input() -> Vector2:
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	return direction
