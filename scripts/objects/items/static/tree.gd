extends StaticBody2D

var health

func damage(attack: Attack) -> void:
	health -= attack.attack_power
	if health <= 0:
		queue_free()

func harvest() -> void:
	print('harvest')
