extends CharacterBody2D

class_name Skeleton

@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@export var hit_state : State

@export var speed : float = 30.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1


signal facing_direction_changed(facing_right : bool)


func _ready():
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state_machine.check_if_can_move():
		velocity.x = direction * speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, speed)

	if wall_detector.is_colliding() or !ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		emit_signal("facing_direction_changed", !sprite.flip_h)
		
		
	move_and_slide()
