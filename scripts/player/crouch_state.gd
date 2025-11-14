extends State

class_name CrouchState


@onready var collision_shape: CollisionShape2D = $"../../CollisionShape2D"

@export var ground_state : State
@export var move_node : String = "move"


func on_enter():
	collision_shape.shape.height = 24
	collision_shape.position.y = 16


func state_input(event : InputEvent):
	if event.is_action_released("down"):
		next_state = ground_state
		playback.travel(move_node)


func on_exit():
	collision_shape.shape.height = 30
	collision_shape.position.y = 13
