extends CharacterBody2D

class_name Player
@export var direction: String = "down"
@export var isAttacking: bool = false
@export var attack_power: int = 10
@export var attack_speed := 1.5

@onready var health_component = %HealthComponent

var my_recipes: Array[Recipe] = []

signal open_modal

func _ready():
	Inv.set_player(self)

func _physics_process(delta: float) -> void:
	if !isAttacking:
		var directionInput = GameInputEvents.movement_input()
		
		if directionInput.x > 0:
			direction = "right"
		if directionInput.x < 0:
			direction = "left"
		if directionInput.y < 0:
			direction = "up"
		if directionInput.y > 0:
			direction = "down"
			
func collect(item: Item) -> void:
	Inv.add_item(item, false)

func collect_recipe(recipe: Recipe) -> void:
	my_recipes.append(recipe)
	open_modal.emit(recipe)

func apply_item_effect(item: Item) -> void:
	if item.type.effect.damage:
		attack_power += item.type.effect.damage
		print('damage increased to ', attack_power)
	if item.type.effect.attack_speed:
		attack_speed += item.type.effect.attack_speed
		print('attack speed increased to ', attack_speed)
	if item.type.effect.heal:
		health_component.health += item.type.effect.heal
		print('healed by ', item.type.effect.heal)
		Global.increase_health.emit(item.type.effect.heal)
	if item.type.effect.max_health:
		health_component.max_health += item.type.effect.max_health 
		print('max health increased by ', item.type.effect.max_health)
		Global.increase_max_health.emit(item.type.effect.max_health)
	Inv.stats_updated.emit()

func use_hotbar_item(slot_index) -> void:
	if slot_index < Inv.hotbar_inventory.size():
		var item = Inv.hotbar_inventory[slot_index]
		if item != null:
			apply_item_effect(item)
			item.qty -= 1
			
			if item.qty <= 0:
				Inv.hotbar_inventory[slot_index] = null
				Inv.remove_item(item)
			Inv.inventory_updated.emit()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		for i in range(Inv.hotbar_size):
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break
