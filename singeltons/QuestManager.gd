extends Node

var quest_bunlde: Dictionary = {}
var all_quests: Array[Node]
var active_quests: Array[Node]
var completed_quests: Array[Node]

var current_step: Node

func start_quest(id: String) -> void:
	for quest in all_quests:
		if quest.quest_id == id and !active_quests.has(quest):
			active_quests.append(quest)
			current_step = quest.get_current_step()
	
# set arrays with quests
func set_qeust_library(quest_lib: Node) -> void:
	all_quests = quest_lib.get_child(0).get_children()
	active_quests = quest_lib.get_child(1).get_children()
	completed_quests = quest_lib.get_child(2).get_children()
	
	print('active_quests ', active_quests)
	print('all_quests ', all_quests)
	quest_bunlde["active_quests"] = active_quests
	quest_bunlde["completed_quests"] = completed_quests
	
func complete_quest(id: String):
	var quest = get_active_quest(id)
	var step = quest.get_current_step()
	
	print('current step ', step)
	quest.apply_rewards()
	step.apply_step_rewards()
	
	completed_quests.append(quest)
	active_quests.erase(quest)
	
	
func complete_step(id:String):
	var quest = get_active_quest(id)
	var step = quest.get_current_step()
	# apply step rewards
	step.apply_step_rewards()
	# remove quest items from inv
	quest.remove_needed_items()
	
	
func get_active_quest(id: String):
	for quest in active_quests:
		if quest.quest_id == id:
			return quest
	
func is_quest_active(id: String) -> bool:
	for quest in active_quests:
		if quest.quest_id == id:
			return true
	return false
	
# get active quest step
func get_active_step(id: String) -> String:
	var active_quest = get_active_quest(id)
	if active_quest:
		current_step = active_quest.get_current_step()
		var current_step_name = active_quest.get_current_step().name
		return current_step_name
	return ''
	
# start next step
func start_next_step(id: String):
	var active_quest = get_active_quest(id)
	var next_step = active_quest.go_to_next_step().name
	
	current_step = active_quest.get_current_step()
	
	return next_step # 02-kill-slime
	
func is_requirements_completed(id: String) -> bool:
	var active_quest = get_active_quest(id)
	var current_step = active_quest.get_current_step()
	
	var step_requirements = current_step.check_step_reqs()
	var need_to_kill = current_step.get_need_to_kill_number()
	var killed_num = current_step.get_killed_num()
	
	if step_requirements == 'both':
		if killed_num == need_to_kill and get_needed_items(id) == true:
			return true
		else:
			return false 
	elif step_requirements == 'collecting':
		return get_needed_items(id)
	elif step_requirements == 'killing':
		if killed_num == need_to_kill:
			return true
		else:
			return false 
	return false
	
	
# get needed items from quest step
func get_needed_items(id: String) :
	for quest in active_quests:
		if quest.quest_id == id:
			return quest.check_items()
