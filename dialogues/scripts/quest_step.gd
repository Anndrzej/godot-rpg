extends Node

@export var id: String
@export var next_step_id: String
@export var step_name: String
@export var step_description: String
@export var items_needed: Array[Item]
@export var step_rewards: Array[Item]
@export var step_killing: Array[EnemyBase]
@export var killed: int = 0
@export var active: bool = false
@export var completed: bool = false

func check_needed_items() -> bool:
	var check = Inv.has_all(items_needed)
	return check
	
func check_step_reqs():
	if step_killing.size() > 0 and items_needed.size() > 0:
		return 'both'
	elif step_killing.size() > 0:
		return 'killing'
	elif items_needed.size() > 0:
		return 'collecting'
	
func get_need_to_kill_number() -> int:
	return step_killing.size()
	
func get_killed_num() -> int:
	return killed
	
func get_current_step() -> String:
	active = true
	return id

#
func activate_step() -> bool:
	active = true
	return active

func apply_step_rewards():
	for i in step_rewards:
		if i.type is Equipment_Item or i.type is Consumable_Item:
			Inv.add_item(i)
			Inv.inventory_updated.emit()
		else:
			print('strange reward....')
			pass
			
		print('switch')
	active = false;
	completed = true;
