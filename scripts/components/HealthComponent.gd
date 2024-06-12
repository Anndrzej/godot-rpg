extends Node
class_name HealthComponent

@export var max_health: float = 20.0

@onready var progress_bar: Control = $"../ProgressBar"

var health: float

func _ready() -> void:
	health = max_health
	
func damage(attack: Attack) -> void:
	health -= attack.attack_power
	var healthbar_progress = (health / max_health) * 100
	if progress_bar:
		progress_bar.set_value(healthbar_progress)
	if health <=0:
		get_parent().queue_free()

func harvest() -> void:
	print('health')
