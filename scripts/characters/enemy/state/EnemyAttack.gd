extends State
class_name EnemyAttack

@export var enemy: CharacterBody2D
@export var attack_power: int = 10
@export var attack_speed := 1.7

@onready var attack_cooldown = %AttackCooldown
@onready var attack_animation = %AttackAnimation

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(_delta) -> void:
	
	#change attack speed animation
	attack_animation.speed_scale = attack_speed
	
	enemy.base.isAttacking = true
	attack_animation.play("attack")
	await attack_animation.animation_finished
	enemy.base.isAttacking = false
	
	chase_state_transition()

func chase_state_transition() -> void:
	
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > 30:
		transition.emit(self, "EnemyChase")

func _on_weapon_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("player_damage"):
		var attack = Attack.new()
		attack.attack_power = attack_power
		area.player_damage(attack)

