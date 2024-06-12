extends Area2D
class_name Attack_Upgrade
@export var upgrade_model : Upgrades


func _on_body_entered(body):
	if body is Player:
		upgrade_model.apply_upgrade(body)
		queue_free()
