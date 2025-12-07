extends State

class_name RunState


@onready var close_range_player_detector: RayCast2D = $"../../CloseRangePlayerDetector"
@onready var long_range_player_detector: RayCast2D = $"../../LongRangePlayerDetector"

@export var attack_state : State
@export var hit_state : State
@export var dead_state : State
@export var run_animation : String = "run"

var just_returned := false


func on_enter():
	playback.travel(run_animation)
	just_returned = true
	

func state_process(delta):
	if just_returned:
		just_returned = false
		return
	
	if _check_for_player(close_range_player_detector):
		return
	
	_check_for_player(long_range_player_detector)


func _check_for_player(detector : RayCast2D):
	if not detector.is_colliding():
		return false
	
	var collider = detector.get_collider()
	
	if collider and collider.is_in_group("Player"):
			print("Fire Wizard detectou o Player!")
			emit_signal("interrupt_state", attack_state)
			return true
	
	return false
