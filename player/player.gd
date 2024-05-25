extends CharacterBody2D

@export var direction: String = "down"
@export var isAttacking: bool = false

func _physics_process(delta: float) -> void:
	if !isAttacking:
		var directionInput = GameInputEvents.movement_input()
		
		if directionInput.x > 0:
			direction = "right"
		if directionInput.x < 0:
			direction = "left"
		if directionInput.y < 0:
			direction = "up"
		if directionInput.y > 0:
			direction = "down"
