extends Node

@export var health_component: HealthComponent

func player_damage(attack: Attack) -> void:
	if health_component:
		health_component.damage(attack)
