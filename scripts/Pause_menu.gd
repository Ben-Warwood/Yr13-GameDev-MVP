extends ColorRect
@onready var animator = $AnimationPlayer
@onready var resume_button : Button = find_child("ResumeButton")
@onready var quit_button : Button = find_child("QuitButton")
var pause_menu_shader: ColorRect # Passed from Player.

func _ready():
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func unpause():
	pause_menu_shader.hide()
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	pause_menu_shader.show()
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
