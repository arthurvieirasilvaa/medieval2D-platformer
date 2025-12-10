extends State

class_name CrouchState


@onready var collision_shape: CollisionShape2D = $"../../CollisionShape2D"
@onready var hitbox_collision_shape: CollisionShape2D = $"../../Hitbox/CollisionShape2D"


@export var ground_state : State
@export var move_node : String = "move"


func on_enter():
	collision_shape.shape.height = 24
	collision_shape.position.y = 16
	
	hitbox_collision_shape.shape.size.y = 25
	hitbox_collision_shape.position.y = 10.5


func state_input(event : InputEvent):
	if event.is_action_released("down"):
		next_state = ground_state
		playback.travel(move_node)


func on_exit():
	collision_shape.shape.height = 30
	collision_shape.position.y = 13
	
	hitbox_collision_shape.shape.size.y = 28.5
	hitbox_collision_shape.position.y = 9
