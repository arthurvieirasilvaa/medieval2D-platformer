extends CharacterBody2D

enum KnightState {
	idle,
	walk,
	attack1,
	death
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector


const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var status: KnightState

var direction = 1

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		KnightState.idle:
			idle_state(delta)
		KnightState.walk:
			walk_state(delta)
		KnightState.attack1:
			attack1_state(delta)
		KnightState.death:
			death_state(delta)

	move_and_slide()


func go_to_idle_state():
	status = KnightState.idle
	animation.play("idle")
	

func go_to_walk_state():
	status = KnightState.walk
	animation.play("walk")
	
	
func go_to_attack1_state():
	status = KnightState.attack1
	animation.play("attack1")	
	velocity = Vector2.ZERO


func go_to_death_state():
	status = KnightState.death
	animation.play("death")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO


func idle_state(_delta):
	pass
	
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if player_detector.is_colliding():
		go_to_attack1_state()
		return
		

func attack1_state(delta):
	pass


func death_state(_delta):
	pass


func take_damage():
	go_to_death_state()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "attack1":
		go_to_walk_state()
		return
