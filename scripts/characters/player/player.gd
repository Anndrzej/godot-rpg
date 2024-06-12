extends CharacterBody2D

class_name Player
@export var direction: String = "down"
@export var isAttacking: bool = false
@export var attack_power: int = 10
@export var attack_speed := 1.5

var inventory: Inventory = Inventory.new() 


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
			
func collect(item:Item) -> void:
	inventory.add_item(item)
