extends RayCast3D

@onready var prompt = $Prompt

func _ready():
	add_exception(owner)
	
func _physics_process(delta):
	prompt.text = ""
	$TextureRect.visible = true
	if is_colliding():
		var detected = get_collider()
		if detected.get_class() == "Interactable":
			prompt.text = detected.get_prompt()
			$TextureRect.visible = false
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
