extends State

class_name GroundState


@onready var buffer_timer: Timer = $BufferTimer
@onready var jump_sfx: AudioStreamPlayer = $"../../AudioController/Jump"
@onready var sword_sfx: AudioStreamPlayer = $"../../AudioController/Sword"

@export var jump_velocity : float = -300.0
@export var air_state : State
@export var jump_preparation_animation : String = "jump_preparation"
@export var flying_up_animation : String = "flying_up"
@export var attack_state : State
@export var attack_animation : String = "attack"
@export var crouch_state : State
@export var crouch_animation : String = "crouch"


func state_process(_delta):
	if !character.is_on_floor() && buffer_timer.is_stopped():
		next_state = air_state
  

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	
	if event.is_action_pressed("attack"):
		attack()
	
	if event.is_action_pressed("down"):
		crouch()
	
	
func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	jump_sfx.play()
	playback.travel(flying_up_animation)


func attack():
	next_state = attack_state
	sword_sfx.play()
	playback.travel(attack_animation)


func crouch():
	next_state = crouch_state
	playback.travel(crouch_animation)
