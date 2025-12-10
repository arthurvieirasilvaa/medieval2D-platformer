extends State

class_name BoneToss

const SPINNING_BONE = preload("res://entities/spinning_bone.tscn")

@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_detector: RayCast2D = $"../../PlayerDetector"
@onready var skeleton: Skeleton = $"../.."

@export var walk_state : State
@export var bone_toss_animation = "bone_toss"
@export var idle_animation = "idle"
@export var pause_between_attacks : float = 0.8

var can_attack : bool = true


func on_enter():
	can_attack = true


func state_process(delta : float) -> void:
	if not player_detector.is_colliding():
		next_state = walk_state
		return
		
	if can_attack:
		throw_bone()
	

func throw_bone():
	can_attack = false
	playback.travel(bone_toss_animation)
		
	var new_bone = SPINNING_BONE.instantiate()
	skeleton.get_parent().add_child(new_bone)
	new_bone.position = skeleton.position
	new_bone.set_direction(skeleton.direction)
	

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name != bone_toss_animation:
		return
	
	playback.travel(idle_animation)
	
	await get_tree().create_timer(pause_between_attacks).timeout
	can_attack = true
