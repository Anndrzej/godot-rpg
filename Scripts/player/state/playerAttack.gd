extends State

class_name PlayerAttack

@export var player: CharacterBody2D
@export var animation: AnimationPlayer 

@export var attack_power: int = 10

func Enter() -> void:
	transition.emit(self, "playerIdle")

func Update(_delta) -> void:
	var direction = GameInputEvents.movement_input()
	
	attack_animation(direction)
	player.isAttacking = true
	await animation.animation_finished
	player.isAttacking = false
	transition.emit(self, "playerIdle")

func attack_animation(direction: Vector2) -> void:
	if player.direction == "right":
		animation.play("attack_right")
	if player.direction == "left":
		animation.play("attack_left")
	if player.direction == "up":
		animation.play("attack_up")
	if player.direction == "down":
		animation.play("attack_down")

func _on_weapon_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		var attack = Attack.new()
		attack.attack_power = attack_power
		area.damage(attack)
	if area.has_method("harvest"):
		print('test')
