extends Node
class_name HealthComponent

@export var max_health: float = 20.0

@onready var progress_bar: Control = $"../ProgressBar"


var health: float
var destroyable_object

func _ready() -> void:
	destroyable_object = get_parent()
	
	health = max_health
	
func damage(attack: Attack) -> void:
	health -= attack.attack_power
	var healthbar_progress = (health / max_health) * 100
	if progress_bar:
		progress_bar.set_value(healthbar_progress)
	if health <= 0:
		if destroyable_object.base.is_quest_enemy:
			var killing_quest = QuestManager.current_step
			print(killing_quest)
			if killing_quest and killing_quest.step_killing.size() > 0:
				killing_quest.killed += 1
		destroyable_object.queue_free()

