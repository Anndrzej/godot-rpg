extends ProgressBar

class_name Health_Bar

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group('Player') 
	
	value = player.health_component.max_health
	
	Global.decrease_health.connect(decrease_health)
	Global.increase_health.connect(increase_health)
	Global.increase_max_health.connect(increase_max_health)

func decrease_health(damage: int):
	var tween = create_tween()
	tween.tween_property(self, "value", value - damage, 0.2)
	
	player.health_component.health -= damage
	
	if value - damage <= 0:
		player.queue_free()
		
func increase_health(heal: int):
	var tween = create_tween()
	tween.tween_property(self, "value", value + heal, 0.2)
	
func increase_max_health(max_health: int):
	var tween = create_tween()
	max_value += max_health
	tween.tween_property(self, "max_value", max_value + max_health, 0.2)
