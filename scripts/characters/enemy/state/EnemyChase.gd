extends State
class_name EnemyChase

var player: CharacterBody2D
@export var enemy: CharacterBody2D

func Enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

func Update(delta) -> void:
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * enemy.move_speed
	enemy.move_and_slide()
	if direction.length() < 30:
		transition.emit(self, "EnemyAttack")


func _on_detection_area_body_exited(body):
	if body is Player:
		transition.emit(self, "EnemyIdle")
