extends Node
@onready var ui_master : Control = $"Player/CanvasLayer/UI master"
@onready var inventory_interface : Control = $"Player/CanvasLayer/UI master/MarginContainer/VBoxContainer2/HBoxContainer2/Inventory"
@onready var player : CharacterBody3D = $"Player"
var player_paused : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player.pause_menu.background_shader = $"PauseShaderBackground"
	ui_master.toggle_inventory.connect(toggle_inventory_interface)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func toggle_inventory_interface():
	inventory_interface.visible = not inventory_interface.visible
	ui_pause()
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func ui_pause():
	player_paused = !player_paused
	player.toggle_movement(player_paused)
	$layer/Camera_Root.camera_pause(player_paused)
