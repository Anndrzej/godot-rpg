extends StaticBody2D

var health = 20

func damage(attack: Attack) -> void:
	health -= attack.attack_power
	if health <= 0:
		queue_free()

