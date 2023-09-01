class_name Player
extends CharacterBody3D

@export var animationtree: NodePath
#signals
signal health_updated(health)
signal stamina_updated(stamina)
signal killed()

@onready var _ik_handle = get_node("Camera_Root/Horizontal/Vertical/Camera3D/HeadHandle")
@onready var _anim_tree = get_node(animationtree)
@onready var _ground_check = $CollisionShape3D/GroundCheck
@onready var _cam_root = $Camera_Root
@onready var pause_menu = $"CanvasLayer/UI master/MarginContainer/VBoxContainer3/HBoxContainer/PauseMenu"
var gravity = 0
var movement = Vector3.ZERO
var direction = Vector3.FORWARD
var angular_acceleration = 7
var acceleration = 20
var air_movement_speed = 2
var can_do_ik = true
var is_walking : bool
var is_running : bool
var is_landing : bool
var is_falling : bool
var is_idle : bool
var can_combo : bool
var can_move : bool = true
var can_attack : bool = true
var did_combo : bool
var can_rotate : bool = true
var combo_counter = 3
var snap = Vector3.DOWN

#attributes
@export var max_health = 100
@onready var health = max_health : set = set_health

@export var max_stamina = 100
@onready var stamina = max_stamina : set = set_stamina
@export var stamina_regen_rate = 0.5


func _ready():
	var state_number = _anim_tree.get("parameters/Movement Transition/current_state")
	#$prototype_robot/Armature/Skeleton3D/LookingIk.start()
	#$prototype_robot/Armature/Skeleton3D/ChestIk.start()
#	$prototype_robot/Armature/Skeleton3D/FootIk_Left.start()
#	$prototype_robot/Armature/Skeleton3D/FootIk_Right.start()
	pass
	
func _process(delta):
	if can_attack:
		Attack(delta)
#	print(combo_counter)
	
	if $StaminaRegenTimer.is_stopped() && stamina != max_stamina:
		stamina += stamina_regen_rate
		emit_signal("stamina_updated", stamina)
		
	_cam_root.global_transform = global_transform
	
	if velocity.y < -20 && !is_on_floor():
		is_falling = true
	else:
		is_falling = false
	
	

func _input(event):
	if event is InputEventMouseMotion:
		pass
		
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.pause()

func _physics_process(delta):
	
#	update_foot_ik_target_pos(_foot_target_left, _foot_raycast_left, _no_ray_cast_left, foot_height_offset)
#	update_foot_ik_target_pos(_foot_target_right, _foot_raycast_right, _no_ray_cast_right, foot_height_offset)
	if can_move:
		if Input.is_action_pressed("forward") || Input.is_action_pressed("back") || Input.is_action_pressed("left") || Input.is_action_pressed("right"):
			if is_on_floor():
					var h_rot = $Camera_Root/Horizontal.global_transform.basis.get_euler().y
					direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0,
					Input.get_action_strength("forward") - Input.get_action_strength("back")).rotated(Vector3.UP, h_rot).normalized()
					_anim_tree.get("parameters/StateMachine/playback").travel("slow run-loop")
					is_running = false;
					is_walking = true
					is_idle = false
					if Input.is_action_pressed("sprint"):
						is_running = true
						is_walking = false
						is_idle = false
						_anim_tree.get("parameters/StateMachine/playback").travel("sprinting-loop")
					
		else:
			is_running = false
			is_walking = false
			is_idle = true
			_anim_tree["parameters/StateMachine/playback"].travel("idle-loop")
				
	
		
#	if (Input.is_action_just_released("sprint") || Input.is_action_pressed("sprint")) && direction == Vector3.ZERO:
#			_anim_tree["parameters/StateMachine/playback"].travel("sprint to stop-loop")
#			is_running = false;

	var root_motion : Vector3 = _anim_tree.get_root_motion_position()
	movement.x = root_motion.x / delta
	movement.z = root_motion.z / delta
	
	var gravity_resistance = _ground_check.get_collision_normal() if is_on_floor() else Vector3.UP
	movement -= gravity_resistance * gravity
	
	if is_on_floor():
		gravity = 0
		movement.y = root_motion.y / delta
		_anim_tree.set("parameters/falling/active",false)
		if is_landing:
			_anim_tree.set("parameters/landing/request",true)
			_anim_tree.set("parameters/Movement Transition/transition_request", "On Ground")
#			print("Should land")
			is_landing = false
		elif !is_landing:
			is_landing = true
	else:
		_anim_tree.set("parameters/landing/active",false)
		gravity += 0.014
		if is_falling:
			_anim_tree.set("parameters/Movement Transition/transition_request", "On Air")
			_anim_tree.set("parameters/falling/active",true)
			can_do_ik = false
			if !is_landing:
				is_landing = true
	#fixing rootmotion stutter
#	if is_walking:
#		movement.z = clamp(movement.z,abs(3),abs(100))
	movement = movement.rotated(Vector3.UP, $prototype_robot.rotation.y)
	set_velocity(movement * 2)	
	move_and_slide()
	if can_rotate && !is_idle:
		$prototype_robot.rotation.y = lerp_angle($prototype_robot.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
		
	if global_transform.origin.y < -100:
		damage_health(randf_range(10,35))
	if Input.is_action_pressed("ui_down"):
		damage_health(20)

func StartComboWindow():
	can_combo = true
	did_combo = false
#	print(combo_counter)
#	print("combo window started")
	$prototype_robot/attack_restart.start()
	if combo_counter == 3:
		combo_counter = 2
	elif combo_counter == 2:
		combo_counter =1
	elif combo_counter == 1:
		combo_counter = 0
	
		
func Attack(delta):
	if can_rotate && _anim_tree.get("parameters/Combo1/active") == true || _anim_tree.get("parameters/Combo2/active") == true || _anim_tree.get("parameters/Combo3/active") == true:
		$prototype_robot.rotation.y = lerp_angle($prototype_robot.rotation.y, $Camera_Root/Horizontal.rotation.y, delta * angular_acceleration)
	else:
		pass
	if Input.is_action_just_pressed("standard attack") && !is_running:
		did_combo = true;
		if combo_counter == 3 && _anim_tree.get("parameters/Combo1/active") != true:
			_anim_tree.set("parameters/Combo1/request",true);
	if Input.is_action_just_pressed("standard attack") && is_running && _anim_tree.get("parameters/SprintAttack/active") != true:
		_anim_tree.set("parameters/SprintAttack/request", true);
		is_running = false;


func attack_finish(anim_name:String):
#	print(anim_name)
	can_combo = false
	if did_combo:
		if anim_name == ("Combo1") && combo_counter == 2:
			_anim_tree.set("parameters/Combo2/request", true)
		elif anim_name == ("Combo2") && combo_counter == 1:
			_anim_tree.set("parameters/Combo3/request", true)
		elif anim_name == ("Combo3") && combo_counter == 0:
			combo_counter = 3
			_anim_tree.set("parameters/Combo1/request",true);
			
	else:
		combo_counter = 3

func toggle_rotation(rotation_window : bool):
	if rotation_window:
		can_rotate = true;
	else:
		can_rotate = false
	


func _on_attack_restart_timeout():
	combo_counter = 3

func update_foot_ik_target_pos(target, raycast, no_raycast, foot_height_offset):
	if raycast.is_colliding():
		var hit_point = raycast.get_collision_point().y + foot_height_offset;
		target.global_transform.origin.y = hit_point
	else:
		target.global_transform.origin.y = no_raycast.global_transform.origin.y
		
func kill():
	pass
	
func damage_health(amount):
	if $InvulnerabilityTimer.is_stopped():
		$InvulnerabilityTimer.start()
		set_health(health - amount)
	
func set_health(value):
	var prev_health = health
	health = clamp(value, 0 , max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
			
func damage_stamina(amount):
	$StaminaRegenTimer.start()
	set_stamina(stamina - amount)
			
func set_stamina(value):
	var prev_stamina = stamina
	stamina = clamp(value, 0 , max_stamina)
	if stamina != prev_stamina:
		emit_signal("stamina_updated", stamina)

func toggle_movement(state : bool):
	can_rotate = state
	can_move = state
	can_attack = state
