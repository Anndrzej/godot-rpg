extends VBoxContainer


@onready var step_title = $StepTitle
@onready var step_description = $StepDescription

func set_quest_labels(title: String, description: String):
	step_title.text = title
	step_description.text = description
