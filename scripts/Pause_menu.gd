extends ColorRect
@onready var animator = $AnimationPlayer
@onready var resume_button : Button = find_child("ResumeButton")
@onready var quit_button : Button = find_child("QuitButton")
@onready var save_button : Button = $"CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Save"
@onready var load_button : Button = $"CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Load"
@onready var options_button : Button = $"CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Options"
@onready var hover_tween :Tween = create_tween()
@onready var return_tween :Tween = create_tween()
@export var button_width : float = 480
@export var button_height : float = 99
var background_shader

var hover_width_offset : int = 100
var hover_height_offset : int = 0

var containers = [resume_button, save_button, load_button, options_button, quit_button]

func _ready():
	hover_tween.set_trans(Tween.TRANS_BOUNCE)
	hover_tween.set_ease(Tween.EASE_IN_OUT)
	
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func _process(delta):
	var cursor_position = get_global_mouse_position()
	if self.visible:
		animate_hovered_button(cursor_position)

func unpause():
	animator.play("Unpause")
	background_shader.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	animator.play("Pause")
	background_shader.show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func animate_hovered_button(cursor_position):
	var container = get_container_under_cursor(cursor_position)
	return_button_animation(container)
	if container:
		if hover_tween:
			hover_tween.kill()
		hover_tween = create_tween()
		hover_tween.tween_property(container, "size", Vector2(button_width + hover_width_offset, button_height + hover_height_offset), 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
		pass

func return_button_animation(current_container):
	containers = [resume_button, save_button, load_button, options_button, quit_button]
	for c in containers:
		if c != current_container or current_container == null:
			if c.size != Vector2(480, 99):
				if return_tween:
#					return_tween.kill()
					pass
				return_tween = create_tween()
				return_tween.tween_property(c, "size", Vector2(button_width, button_height), 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
		else:
			pass
			

func get_container_under_cursor(cursor_position):
	containers = [resume_button, save_button, load_button, options_button, quit_button]
	#creates array of containers
	for c in containers:
		if c.get_global_rect().has_point(cursor_position):
		#checks if the cursor is within the rectangle shape of the containers
			return c
			# returns which container the cursor is in
	return null
	


