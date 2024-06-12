extends StaticBody2D

class_name CollectableResource

@onready var interact_text: Control = $InteractText
@onready var interaction_progress_bar: Control = $InteractionProgressBar

var interact_speed: float
var body

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interact_text.visible = true

func _ready():
	set_process(false)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interact_text.visible = false

func _process(delta):
	if Input.is_action_pressed("interract"):
		interact(interact_speed, body)

func interact(speed: float, interactedBody) -> void:
	interact_speed = speed
	body = interactedBody
	interaction_progress_bar.test_value(interact_speed, body)
	set_process(true)

func _on_resource_area_body_exited(body):
	if body.is_in_group("Player"):
		set_process(false)
