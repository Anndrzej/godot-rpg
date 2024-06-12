extends CanvasLayer


@export var all_recipes: ResourceGroup
@onready var player: CharacterBody2D = %Player
@onready var inventory_dialog: InventoryDialog = $InventoryDialog
@onready var crafting_dialog: CraftingDialog = %CraftingDialog

var _all_recipes: Array[Recipe] = []

func _ready():
	all_recipes.load_all_into(_all_recipes)

func _unhandled_input(event):
	var inventory = GameInputEvents.inventory_input()
	var crafting = GameInputEvents.crafting_input()
	if inventory: 
		inventory_dialog.open(player.inventory)
	if crafting:
		crafting_dialog.open(_all_recipes, player.inventory)
