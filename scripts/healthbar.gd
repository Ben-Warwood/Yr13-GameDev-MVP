extends Control

@onready var Healthbar = $Healthbar
@onready var Healthbarunder = $Healthbarunder
@onready var Staminabar = $StaminaBar
@onready var Staminabarunder = $StaminaBarunder
@onready var update_tween :Tween = create_tween()

func _ready():
	update_tween.set_trans(Tween.TRANS_EXPO)
	update_tween.set_ease(Tween.EASE_IN_OUT)
	on_health_updated(100)
	on_stamina_updated(100)
	pass

func on_health_updated(health):
	print(health)
	Healthbar.value = health
	var ranga : float = health
	if update_tween:
		update_tween.kill()
	update_tween = create_tween()
	update_tween.tween_property(Healthbarunder, "value", health, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
	
func on_max_health_updated(max_health):
	Healthbar.max_value = max_health
	Healthbarunder.max_value = max_health
	
func on_stamina_updated(stamina):
	
	Staminabar.value = stamina
	if update_tween:
		update_tween.kill()
	update_tween = create_tween()
	update_tween.tween_property(Staminabarunder, "value", stamina, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
func on_max_stamina_updated(max_stamina):
	Staminabar.max_value = max_stamina
	Staminabarunder.max_value = max_stamina

func on_stamina_restored(stamina,amount):
	Staminabarunder.value = stamina + amount
	Staminabar.value = stamina + amount

