extends State

class_name WalkState


@onready var player_detector: RayCast2D = $"../../PlayerDetector"


@export var attack_state : State
@export var hit_state : State
@export var death_state : State
@export var walk_animation : String = "walk"


func on_enter():
	playback.travel(walk_animation)


func state_process(delta):
	if player_detector.is_colliding():
		var collider = player_detector.get_collider()
		
		if collider and collider.is_in_group("Player"):
			emit_signal("interrupt_state", attack_state)
