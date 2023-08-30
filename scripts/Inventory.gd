extends Control

#intantiating item base
const item_base = preload("res://scenes/item_base.tscn")

# references
@onready var equipment_slots = $EquipmentSlots
@onready var inventory_base = $InventoryBase
@onready var grid_bkpk = $GridBackPack

#setting up variables
var item_held = null
var item_offset = Vector2()
var last_container = null
var last_position = Vector2()

func _ready():
	pickup_item("sword")
	pickup_item("breastplate")
	pickup_item("sword")
	pickup_item("potato")
	pickup_item("breastplate")
	pickup_item("sword")
	pickup_item("potato")
	pickup_item("potato")
	pickup_item("dkfhdso")

func _process(_delta):
# Input calculations
	var cursor_position = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_click"):
		grab(cursor_position)
	if Input.is_action_just_released("inv_click"):
		release(cursor_position)
	if item_held != null:
	#If holding something
		item_held.global_position = cursor_position + item_offset
		# Make it follow the cursor with offset
	if Input.is_action_just_released("interact"):
		pickup_item("potato")
		
func grab(cursor_position):
	var c = get_container_under_cursor(cursor_position)
	#if we successfully grabbed an item and it has the grab item method
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_position)
		#call grab item, set item held to item or null
		if item_held != null:
			last_container = c
			last_position = item_held.global_position
			item_offset = item_held.global_position - cursor_position
			#record last container and position + calculate item offset
			move_child(item_held, get_child_count())
			# moves item we grabbed to render on top in child hierachy
	
func release(cursor_position):
	if item_held == null:
		return
	var c = get_container_under_cursor(cursor_position)
	if c == null:
		drop_item()
		#if theres no container when underneath when item released, drop the item
	elif c.has_method("insert_item"):
		if c.insert_item(item_held):
			item_held = null
			# if there is a container with insert item method, stop holding item
		else:
			return_item()
	else:
		return_item()
		#if not return the item to the previous container
	
func get_container_under_cursor(cursor_position):
	#creates array of containers
	var containers = [grid_bkpk, equipment_slots, inventory_base]
	for c in containers:
		if c.get_global_rect().has_point(cursor_position):
		#checks if the cursor is within the rectangle shape of the containers
			return c
			# returns which container the cursor is in
	return null
	
func drop_item():
	item_held.queue_free()
	item_held = null
	
	
func return_item():
	item_held.global_position = last_position
	last_container.insert_item(item_held)
	item_held = null

func pickup_item(item_id):
	print("Picking up item: ", item_id)

	var item = item_base.instantiate()
	item.set_meta("id", item_id)
	item.texture = load(ItemDb.get_item(item_id)["icon"])
	add_child(item)
	if !grid_bkpk.insert_item_at_first_available_spot(item):
		print("Failed to insert ", item_id ," into backpack.")
		item.queue_free()
		return false
	print("inserted item at ", item.position)
	return true

	
	
	
