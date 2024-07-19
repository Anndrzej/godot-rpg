extends Node

func player_damage(attack: Attack) -> void:
	Global.decrease_health.emit(attack.attack_power)
	Inv.stats_updated.emit()
