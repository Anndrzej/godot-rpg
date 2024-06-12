class_name Inventory

var _collection: Array[Item] = []

func add_item(item: Item) -> void: 
	if (_collection.has(item)):
		remove_item(item)
	_collection.append(item)

func remove_item(item: Item) -> void: 
	_collection.erase(item)
	
	
func craft_item(item: Item):
	item.qty -= item.ingredients_qty
	
	if (_collection.has(item)):
		remove_item(item)
	_collection.append(item)
	

func get_items() -> Array[Item]: 
	return _collection

func has_all(items: Array[Item]) -> bool:
	var needed:Array[Item] = items.duplicate()
	
	for available in _collection:
		if available.qty >= available.ingredients_qty:
			needed.erase(available)
	return needed.is_empty()
