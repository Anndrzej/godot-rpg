extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func test_value(value: int, body) -> void:
	texture_progress_bar.value += value
	if texture_progress_bar.value == 100:
		body.queue_free()

