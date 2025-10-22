extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump_preparation,
	flying_up,
	landing
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var status: PlayerState

func _ready() -> void:
	go_to_idle_state()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump_preparation:
			jump_preparation_state()
		PlayerState.flying_up:
			flying_up_state()
		PlayerState.landing:
			landing_state()
		
	move_and_slide()


func go_to_idle_state():
	status = PlayerState.idle
	animation.play("idle")


func go_to_walk_state():
	status = PlayerState.walk
	animation.play("walk")
	

func go_to_jump_preparation_state():
	status = PlayerState.jump_preparation	
	animation.play("jump_preparation")
	

func go_to_flying_up_state():
	status = PlayerState.flying_up
	animation.play("flying_up")


func go_to_landing_state():
	status = PlayerState.landing
	animation.play("landing")


func idle_state():
	move()
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return	


func walk_state():
	move()
	
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return
	
	
func jump_preparation_state():
	move()
	
	if animation.frame == animation.sprite_frames.get_frame_count("jump_preparation") - 1:
		velocity.y = JUMP_VELOCITY
		go_to_flying_up_state()
		return


func flying_up_state():
	move()
	
	if is_on_floor():
		go_to_landing_state()
		return


func landing_state():
	move()

	if animation.frame == animation.sprite_frames.get_frame_count("landing") - 1:
		if velocity.x == 0:
			go_to_idle_state() 
		else:
			go_to_walk_state()
		return


func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false
