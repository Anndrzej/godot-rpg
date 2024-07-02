extends State

class_name playerIneraction

var interraction_speed: float = 1.0
@onready var interaction_area: CollisionShape2D = $"../../InteractionArea/CollisionShape2D"

func Enter() -> void:
	interaction_area.disabled = false 

func Update(_delta) -> void:
	if !Input.is_action_just_pressed("attack"):
		interaction_area.disabled = true 
		transition.emit(self, "playerIdle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CollectableResource:
		body.interact(interraction_speed, body)
