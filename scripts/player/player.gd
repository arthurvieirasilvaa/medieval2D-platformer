extends CharacterBody2D

class_name Player


@export var speed : float = 120.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0


signal facing_direction_changed(facing_right : bool)


func _ready() -> void:	
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	direction = Input.get_axis("left", "right")
	if direction != 0 && state_machine.check_if_can_move():
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation_paramaters()
	update_facing_direction() 


func update_animation_paramaters():
	animation_tree.set("parameters/move/blend_position", direction)
	

func update_facing_direction():
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	emit_signal("facing_direction_changed", !sprite.flip_h)
