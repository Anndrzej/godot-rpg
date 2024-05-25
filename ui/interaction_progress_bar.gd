extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var test: bool = false
func _process(delta: float) -> void:
	test = GameInputEvents.interract_input()
func test_value(value: int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(texture_progress_bar, "value", 100, 1).set_trans(Tween.TRANS_LINEAR)

