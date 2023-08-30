extends TextureRect

#variables
var items = []
var grid = {}
var cell_size = 32
var grid_height = 0
var grid_width = 0

	
func _ready():
	var s = get_grid_size(self)
	grid_width = s.x
	grid_height = s.y
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			grid[x][y] = false
			
func insert_item(item):
	var item_position = item.global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_position = position_to_grid_coord(item_position)
	var item_size = get_grid_size(item)
	if is_grid_space_available(g_position.x,g_position.y, item_size.x, item_size.y):
		# if the space is unoccupied
		set_grid_space(g_position.x,g_position.y, item_size.x, item_size.y, true)
		item.global_position = global_position + Vector2(g_position.x, g_position.y) * cell_size
		# move to grid space
		items.append(item)
		return true
	else:
		return false
	
func grab_item(position):
	var item = get_item_under_position(position)
	if item == null:
		return null
		
	var item_position = item.global_position + Vector2(cell_size / 2, cell_size / 2)	
	var g_position = position_to_grid_coord(item_position)
	var item_size = get_grid_size(item)
	set_grid_space(g_position.x, g_position.y, item_size.x, item_size.y, false)
	
	items.erase(items.find(item))
	return item
	
func get_item_under_position(position):
	
	for item in items:
		if item != null:
			if item.get_global_rect().has_point(position):
				return item
			# check all items to see if it has our cursor position, return the item that does
	return null
	
func set_grid_space(x, y, w, h, state):
	for i in range(x, x + w):
		for j in range(y, y + h):
			grid[i][j] = state
	
func is_grid_space_available(x, y, w, h):
	if x < 0 or y < 0:
		return false
	if x + w > grid_width or y + h > grid_height:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if grid[i][j]:
				return false
	return true
	
func position_to_grid_coord(position):
	var local_position = position - global_position
	var results = {}
	results.x = int(local_position.x / cell_size)
	results.y = int(local_position.y / cell_size)
	return results
	
func get_grid_size(item):
	var results = {}
	var s = item.size
	results.x = clamp(int(s.x / cell_size), 1, 500)
	results.y = clamp(int(s.y / cell_size), 1, 500)
	return results
	print("results: ",results)
	
func insert_item_at_first_available_spot(item):
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.global_position = global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false
