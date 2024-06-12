extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed: float = 50.0
@onready var animation = %AnimatedSprite2D

var move_direction: Vector2
var wander_time: float

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter() -> void:
	randomize_wander()
	
func Update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float) -> void:
	animation.play("walk_horizontal")
	
	if enemy.velocity.x < 0:
		animation.flip_h = true
	else :
		animation.flip_h = false
	
	if enemy: 
		enemy.velocity = move_direction * move_speed
	enemy.move_and_slide()

func _on_detection_area_body_entered(body):
	if body is Player:
		transition.emit(self, "enemyChase")
