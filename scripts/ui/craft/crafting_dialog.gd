extends PanelContainer

class_name CraftingDialog

@onready var grid_result: GridContainer = %GridResult
@onready var grid_ingredients: GridContainer = %GridIngredients
@onready var recipe_list: ItemList = %RecipeList
@onready var craft: Button = %Craft

var _inventory: Inventory
var _selected_recipe: Recipe

func open(recipes: Array[Recipe], inventory: Inventory) -> void:
	_inventory = inventory
	
	show()
	
	recipe_list.clear()

	for recipe in recipes:
		var index = recipe_list.add_item(recipe.name)
		recipe_list.set_item_metadata(index, recipe)
		
	recipe_list.select(0)
	
	_on_recipe_list_item_selected(0)
	
func _on_recipe_list_item_selected(index):
	_selected_recipe = recipe_list.get_item_metadata(index)
	grid_ingredients.displayIngredients(_selected_recipe.ingredients)
	grid_result.displayIngredients(_selected_recipe.results)
	craft.disabled = not _inventory.has_all(_selected_recipe.ingredients)

func _on_button_pressed():
	hide()

func _on_craft_pressed():
	for item in _selected_recipe.ingredients:
		_inventory.craft_item(item)
	#update ingredients quantity in craft dialog
	grid_ingredients.displayIngredients(_selected_recipe.ingredients)
	
	for item in _selected_recipe.results:
		if _inventory._collection.has(item):
			#check if item has qty
			if item.qty == 0:
				item.qty = 1
			item.qty += 1
			
		_inventory.add_item(item)
		
	craft.disabled = not _inventory.has_all(_selected_recipe.ingredients)
