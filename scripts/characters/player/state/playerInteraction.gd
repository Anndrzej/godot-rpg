extends State

class_name playerIneraction

var interaction_speed: float = 1.0
@onready var interaction_area: CollisionShape2D = %CollisionShape2D

func Enter() -> void:
	interaction_area.disabled = false 

func Update(_delta) -> void:
	if !Input.is_action_just_pressed("attack"):
		transition.emit(self, "playerIdle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CollectableResource:
		body.interact(interaction_speed, body)
