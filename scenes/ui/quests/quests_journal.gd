extends Control

@onready var quest_list = %QuestList
@onready var quest_name = %QuestName
@onready var quest_description = %QuestDescription
@onready var quests_container = %QuestsContainer

var quest_description_scene: PackedScene = preload("res://scenes/ui/quests/quest_description_container.tscn")

var _selected_quest: Node
var quests: Dictionary

func open_journal(all_quests: Dictionary) -> void:
	quests = all_quests
	print('all_quests ', all_quests)
	if all_quests.size() > 0:
		quest_list.clear()
		update_quests(quests.active_quests)

func update_quests(quests: Array[Node]):
	quest_list.clear()

	for quest in quests:
		var quest_index = quest_list.add_item(quest.quest_name)
		quest_list.set_item_metadata(quest_index, quest)

	_on_quest_list_item_selected(0)

func _on_quest_list_item_selected(index):
	_selected_quest = quest_list.get_item_metadata(index)
	if _selected_quest:
		quest_name.text = _selected_quest.quest_name
		update_quest_description(_selected_quest)

func update_quest_description(quest: Node):
	if quests_container.get_child_count() > 0:
		for child in quests_container.get_children():
			child.queue_free()

	var quest_steps = quest.get_all_quest_steps()
	for step in quest_steps:
		if step.active:
			var quest_desc = quest_description_scene.instantiate()
			quests_container.add_child(quest_desc)
			quest_desc.set_quest_labels(step.step_name, step.step_description)
			print(step.completed)
			if step.completed:
				quest_desc.set_quest_labels("[s]%s[/s]" % step.step_name, "[s]%s[/s]" % step.step_description)

func _on_active_quests_button_pressed():
	update_quests(quests.active_quests)

func _on_archived_quests_button_pressed():
	update_quests(quests.completed_quests)

func _on_close_button_pressed():
	hide()
