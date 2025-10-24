extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump_preparation,
	flying_up,
	falling,
	landing,
	crouch,
	sliding
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


@export var max_speed = 120.0
@export var acceleration = 400
@export var deceleration = 400
@export var slide_deceleration = 100

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
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump_preparation:
			jump_preparation_state(delta)
		PlayerState.flying_up:
			flying_up_state(delta)
		PlayerState.falling:
			falling_state(delta)
		PlayerState.landing:
			landing_state(delta)
		PlayerState.crouch:
			crouch_state(delta)
		PlayerState.sliding:
			sliding_state(delta)
		
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


func go_to_falling_state():
	status = PlayerState.falling
	animation.play("falling")


func go_to_landing_state():
	status = PlayerState.landing
	animation.play("landing")
	
	
func go_to_crouch_state():
	status = PlayerState.crouch
	animation.play("crouch")
	set_crouch_collider()


func exit_from_crouch_state():
	set_large_collider()


func go_to_sliding_state():
	status = PlayerState.sliding
	animation.play("sliding")
	set_sliding_collider()
	

func exit_from_sliding_state():
	set_large_collider()
	
	
func idle_state(delta):
	move(delta)
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return	

	if Input.is_action_pressed("crouch") and is_on_floor():
		go_to_crouch_state()
		return


func walk_state(delta):
	move(delta)
	
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return
	
	if !is_on_floor():
		jump_count += 1
		go_to_falling_state()
		return
		
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		go_to_sliding_state()
		return
	
func jump_preparation_state(delta):
	move(delta)
	
	if animation.frame == animation.sprite_frames.get_frame_count("jump_preparation") - 1:
		go_to_flying_up_state()
		return


func flying_up_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") and can_jump():
		go_to_flying_up_state()
		return
		
	if velocity.y > 0:
		go_to_falling_state()
		return	
		
	if is_on_floor():
		go_to_landing_state()
		return


func falling_state(delta):
	move(delta)

	if Input.is_action_just_pressed("jump") and can_jump():
		go_to_flying_up_state()
		return
	
	if is_on_floor():
		go_to_landing_state()
		return

func landing_state(delta):
	move(delta)

	if animation.frame == animation.sprite_frames.get_frame_count("landing") - 1:
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return


func crouch_state(_delta):
	update_direction()
	
	if Input.is_action_just_released("crouch"):
		exit_from_crouch_state()
		go_to_idle_state();
		return
	
	
func sliding_state(delta):
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)	
	
	if Input.is_action_just_released("crouch"):
		exit_from_sliding_state()
		go_to_walk_state()
		return
		
	if velocity.x == 0:
		exit_from_sliding_state()
		go_to_crouch_state()
		return
	
	
func move(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)	
	

func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false


func can_jump() -> bool:
	return jump_count < max_jump_count


func set_crouch_collider():
	collision_shape.shape.radius = 12
	collision_shape.shape.height = 25
	collision_shape.position.y = 1
	
	
func set_sliding_collider():
	collision_shape.shape.radius = 13
	collision_shape.shape.height = 26
	collision_shape.position.y = 5


func set_large_collider():
	collision_shape.shape.radius = 14
	collision_shape.shape.height = 30
	collision_shape.position.y = 6
