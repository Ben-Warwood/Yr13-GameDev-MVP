extends TextureRect

@onready var slots = get_children()
var items = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for slot in slots:
		items[slot.name] = null
		# sets index ids for items based on children of node
		print (slots)
		
func insert_item(item):
	var item_position = item.global_position + item.size / 2
	var slot = get_slot_under_position(item_position)
	
	var item_slot = ItemDb.get_item(item.get_meta("id"))["slot"]
	# get metadata with id and find itém's slot
	if slot == null:
		return false
	if item_slot != slot.name:
		return false
		print("cannot insert")
		# see if slot matches
	if items[item_slot] != null:
		return false
		# see if slots already occupied
	items[item_slot] = item
	#otherwise set slot to be that item
	item.global_position = slot.global_position + slot.size / 2 - item.size / 2 
	print("slot name is ", slot.name)
	return true
	# move item to position
	
func grab_item(position):
	var item = get_item_under_position(position)
	if item == null:
		return null
		
	var item_slot = ItemDb.get_item(item.get_meta("id"))["slot"]
	items[item_slot] = null
	return item
	
func get_slot_under_position(position):
	return get_thing_under_position(slots, position)
	
func get_item_under_position(position):
	return get_thing_under_position(items.values(), position)

func get_thing_under_position(array, position):
	for thing in array:
		if thing != null and thing.get_global_rect().has_point(position):
			return thing
			# if rectangles overlap return thing
	return null
