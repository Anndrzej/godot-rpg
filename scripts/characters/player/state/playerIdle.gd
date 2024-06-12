extends State
class_name PlayerIdle

@export var player: CharacterBody2D
@export var animation: AnimatedSprite2D

func Enter() -> void:
	pass

func Update(_delta) -> void:
	var direction = GameInputEvents.movement_input()
	var attack = GameInputEvents.attack_input()
	var interract = GameInputEvents.interract_input()
	
	idle_animation(direction)
	if direction != Vector2.ZERO:
		transition.emit(self, "playerMove")
		
	if attack:
		transition.emit(self, "playerAttack")
		
	if interract:
		transition.emit(self, "playerInteract")

func idle_animation(direction: Vector2) -> void:
	if player.direction == "right":
		animation.play("idle_right")
	if player.direction == "left":
		animation.play("idle_left")
	if player.direction == "up":
		animation.play("idle_up")
	if player.direction == "down":
		animation.play("idle_down")
