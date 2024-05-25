extends StaticBody2D

class_name CollectableResource

@onready var interact_text: Control = $InteractText
@onready var interaction_progress_bar: Control = $InteractionProgressBar

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interact_text.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interact_text.visible = false

func interact(speed: float) -> void:
	interaction_progress_bar.test_value(1)
