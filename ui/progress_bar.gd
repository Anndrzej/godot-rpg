extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	hide()
	
func set_value(value) -> void:
	texture_progress_bar.value = value
	
	if value < 100:
		show()
	else: 
		hide()
