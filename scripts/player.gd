extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump_preparation,
	flying_up,
	landing,
	crouch
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
var direction = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0
	
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
		PlayerState.crouch:
			crouch_state()
		
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
	velocity.y = JUMP_VELOCITY
	animation.play("flying_up")
	jump_count += 1

func go_to_landing_state():
	status = PlayerState.landing
	animation.play("landing")
	
	
func go_to_crouch_state():
	status = PlayerState.crouch
	animation.play("crouch")
	collision_shape.shape.radius = 12
	collision_shape.shape.height = 25
	collision_shape.position.y = 1
	
	
func exit_from_crouch_state():
	collision_shape.shape.radius = 14
	collision_shape.shape.height = 28
	collision_shape.position.y = 8


func idle_state():
	move()
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return	

	if Input.is_action_pressed("crouch") and is_on_floor():
		go_to_crouch_state()
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
		go_to_flying_up_state()
		return


func flying_up_state():
	move()
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		go_to_flying_up_state()
		
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


func crouch_state():
	update_direction()
	
	if Input.is_action_just_released("crouch"):
		exit_from_crouch_state()
		go_to_idle_state();
		return
		

func move():
	update_direction()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false
