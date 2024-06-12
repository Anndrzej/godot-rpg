class_name Attack_Damage
extends Upgrades

func apply_upgrade(player: Player):
	print('worked')
	player.attack_power += 25.0
