extends Node3D

@onready var _player_sight = get_parent().get_node("prototype_robot/Sight_area/CollisionShape3D")
var camrot_h = 0
var camrot_v = 0
var h_sensetivity = 0.2
var v_sensitivity = 0.2
var h_acceleration = 10
var v_acceleration = 10
var controller_h_sensitivity = 3
var controller_v_sensitivity = 2
var cam_v_max = 75
var cam_v_min = -55
var axis_vector = Vector2.ZERO

var can_cam_rotate : bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	$Horizontal/Vertical/Camera3D.add_exception(get_parent())
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == (Input.MOUSE_MODE_CAPTURED):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * h_sensetivity
		camrot_v += event.relative.y * v_sensitivity
	elif event is InputEventJoypadMotion:
		axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		
func _physics_process(delta):
	if can_cam_rotate:
		mouse_rotation(delta)
#		apply_controller_rotation(delta)
	
func apply_controller_rotation(delta):
	$Horizontal/Vertical.rotation.x = clamp($Horizontal/Vertical.rotation.x, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	$Horizontal.rotate_y(deg_to_rad(-axis_vector.x) * controller_h_sensitivity)
	$Horizontal/Vertical.rotate_x(deg_to_rad(axis_vector.y) * controller_v_sensitivity)

func mouse_rotation(delta):
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	$Horizontal.rotation_degrees.y = lerpf($Horizontal.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$Horizontal/Vertical.rotation_degrees.x = lerpf($Horizontal/Vertical.rotation_degrees.x, camrot_v, delta * v_acceleration)


func camera_pause(state : bool):
	can_cam_rotate = state
