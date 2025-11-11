extends State

class_name AirState

@export var landing_state : State
@export var flying_up_animation : String = "flying_up"
@export var falling_animation : String = "falling"
@export var double_jump_velocity : float = -120.0

var has_double_jumped : bool = false


func state_process(_delta):
	if character.is_on_floor():
		next_state = landing_state


func state_input(event : InputEvent):
	if event.is_action_pressed("jump") && !has_double_jumped:
		double_jump()


func on_exit():
	if next_state == landing_state:
		playback.travel(falling_animation) 
		has_double_jumped = false


func double_jump():
	next_state = null  # cancela qualquer landing pendente
	character.velocity.y = double_jump_velocity
	playback.travel(flying_up_animation)
	has_double_jumped = true
