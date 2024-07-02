extends State
class_name PlayerMove
@export var player: CharacterBody2D
@export var animation: AnimatedSprite2D
@export var speed: int = 100

func Enter() -> void:
	pass

func Update(_delta) -> void:
	var direction = GameInputEvents.movement_input()
	
	player.velocity = direction * speed
	
	move_animation(direction)
	
	player.move_and_slide()
	
	if player.velocity == Vector2.ZERO:
		transition.emit(self, "playerIdle")
	
	if Input.is_action_just_pressed("attack"):
		transition.emit(self, "playerAttack")

func move_animation(direction: Vector2) -> void:
	if player.direction == "right":
		animation.play("walk_right")
	if player.direction == "left":
		animation.play("walk_left")
	if player.direction == "up":
		animation.play("walk_up")
	if player.direction == "down":
		animation.play("walk_down")
