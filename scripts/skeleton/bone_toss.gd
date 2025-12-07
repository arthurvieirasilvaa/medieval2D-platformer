extends State

class_name BoneToss

@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_detector: RayCast2D = $"../../PlayerDetector"

@export var walk_state : State
@export var bone_toss_animation = "bone_toss"
@export var pause_between_attacks : float = 0.8


func on_enter():
	_play_attack()


func _play_attack():
	await get_tree().process_frame
	playback.travel(bone_toss_animation)


func state_process(_delta : float) -> void:
	if not player_detector.is_colliding():
		next_state = walk_state


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name != bone_toss_animation:
		return
		
	if player_detector.is_colliding():
		await get_tree().create_timer(pause_between_attacks).timeout
		_play_attack()
	
	else:
		next_state = walk_state
