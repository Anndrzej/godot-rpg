extends CanvasLayer


@export var all_recipes: ResourceGroup
@onready var player: CharacterBody2D = %Player
@onready var inventory_dialog: InventoryDialog = $InventoryDialog
@onready var crafting_dialog: CraftingDialog = %CraftingDialog
#
var _all_recipes: Array[Recipe] = [] # залишити на випадок якщо потрібно буде показати всі рецепти які є, а ті які в мене є підсвічувати
func _ready():
	all_recipes.load_all_into(_all_recipes)
	
func _unhandled_input(event):
	if Input.is_action_pressed("inventory"):
		inventory_dialog.visible = !inventory_dialog.visible
		
	if Input.is_action_pressed("crafting"):
		crafting_dialog.visible = !crafting_dialog.visible
		crafting_dialog.open(player.my_recipes)
		
