extends Resource

class_name EnemyBase

enum types { MElEE, RANGE }
@export var enemy_name: String
@export var scene: PackedScene
@export var mode: types
@export var isAttacking: bool = false
@export var move_speed: float
@export var is_quest_enemy: bool
