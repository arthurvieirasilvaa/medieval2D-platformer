extends State


@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var close_range_player_detector: RayCast2D = $"../../CloseRangePlayerDetector"
@onready var long_range_player_detector: RayCast2D = $"../../LongRangePlayerDetector"

@export var run_state : State
@export var attack_animations: Array[String] = ["attack1", "flame_jet"]

var attacking = false


func on_enter():
	attacking = true
	await get_tree().process_frame

	var chosen_attack = _choose_attack()
	if chosen_attack != "":
		playback.travel(chosen_attack)
	
	else:
		attacking = false
		next_state = run_state


func state_process(_delta : float) -> void:
	if not close_range_player_detector.is_colliding() and not long_range_player_detector.is_colliding() and not attacking:
		next_state = run_state


func on_exit():
	attacking = false
	
	
func _choose_attack():
	if close_range_player_detector.is_colliding():
		return attack_animations[0]
	
	elif long_range_player_detector.is_colliding():
		return attack_animations[1]
	
	return ""


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:	
	if not attacking:
		return
	
	if anim_name in attack_animations:
		attacking = false
		next_state = run_state
