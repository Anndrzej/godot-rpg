extends PanelContainer

class_name CraftingDialog

@onready var grid_result: GridContainer = %GridResult
@onready var grid_ingredients: GridContainer = %GridIngredients
@onready var recipe_list: ItemList = %RecipeList
@onready var recipe_type_list = %RecipeCategoryList
@onready var craft: Button = %Craft

var _selected_recipe: Recipe
var recipe_categories: Dictionary = {}

func _ready():
	craft.disabled = true

func open(recipes: Array[Recipe]) -> void:
	if recipes.size() > 0:
		recipe_type_list.clear()
		for recipe in recipes:
			var recipe_category = recipe.category
			
			if recipe_category in recipe_categories:
				if not recipe_categories[recipe_category].has(recipe):
					recipe_categories[recipe_category].append(recipe)
			else: 
				recipe_categories[recipe_category] = [recipe]
			
		for cat in recipe_categories:
			var category_index = recipe_type_list.add_item(cat)
			recipe_type_list.set_item_metadata(category_index, recipe_categories[cat])
			
		_on_recipe_type_list_item_selected(0)
		

func _on_recipe_type_list_item_selected(index):
	var selected_category = recipe_type_list.get_item_metadata(index)
	
	recipe_list.clear()
	print(selected_category)
	for i in selected_category:
		var item_index = recipe_list.add_item(i.name)
		recipe_list.set_item_metadata(item_index, i)
	_on_recipe_list_item_selected(0)
	recipe_list.select(0)
	
	
func _on_recipe_list_item_selected(index):
	_selected_recipe = recipe_list.get_item_metadata(index)
	print(_selected_recipe)
	grid_ingredients.displayIngredients(_selected_recipe.ingredients)
	grid_result.displayIngredients(_selected_recipe.results)
	craft.disabled = not Inv.has_all(_selected_recipe.ingredients)

func _on_button_pressed():
	hide()

func _on_craft_pressed():
	for item in _selected_recipe.ingredients:
		Inv.craft_item(item)
	grid_ingredients.displayIngredients(_selected_recipe.ingredients)
	
	for item in _selected_recipe.results:
		Inv.add_craft_item(item)
		
	craft.disabled = not Inv.has_all(_selected_recipe.ingredients)


