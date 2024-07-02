extends Control

@onready var icon = %Icon
@onready var recipe_name = %RecipeName
@onready var close_btn = %CloseBtn

var player 

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.open_modal.connect(_on_open_modal)
	
func _on_open_modal(data):
	icon.texture = data.icon
	recipe_name.text = data.name
	visible = true
	print(visible)


func _on_close_btn_pressed():
	hide()
