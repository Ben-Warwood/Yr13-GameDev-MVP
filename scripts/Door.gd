extends Node3D

@export var open = false
var is_opening = false
var playback = null
var _anim_tree_player
var hand_loc
var _anim_tree = null 
var robot_model
func _ready():
	_anim_tree = $Door/AnimationTree.get("parameters/playback")
	pass


func _on_Door_interacted(body):
	is_opening = !is_opening
	_anim_tree.travel("Opening_door")
	_anim_tree_player = body.find_child("AnimationTree")
	_anim_tree_player.set("parameters/Opendoor/active",true)
	
	body.global_transform.origin.z = $Marker3D.global_transform.origin.z
	body.global_transform.origin.x = $Marker3D.global_transform.origin.x
	robot_model = body.find_child("prototype_robot")
	
	robot_model.rotation.y = $Marker3D.rotation.y
func _physics_process(delta):
# MORE STUFF FOR AIMING AT THE HAND
	if is_opening:
#		rotation.y = lerp_angle(rotation.y, atan2((hand_loc.global_transform.origin.x - 
#		global_transform.origin.x), (hand_loc.global_transform.origin.z - global_transform.origin.z)), delta * 10)
		pass
func toggle_collider():
	if 	$Door/CollisionShape3D.disabled == false:
		$Door/CollisionShape3D.disabled = true
	else:
		$Door/CollisionShape3D.disabled = false
