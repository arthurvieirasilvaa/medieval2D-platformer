extends State

class_name AttackState


@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_detector: RayCast2D = $"../../PlayerDetector"

@export var walk_state : State
@export var attack_animations: Array[String] = ["attack1", "attack2", "attack3"]


var attacking = false


func on_enter():
	attacking = true
	await get_tree().process_frame
	playback.travel(attack_animations[0])


func state_process(_delta : float) -> void:
	if not player_detector.is_colliding() and not attacking:
		next_state = walk_state


func on_exit():
	attacking = false

		
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if not attacking:
		return
		
	if anim_name == "attack1":
		if attacking:	
			playback.travel(attack_animations[1])
		else:
			next_state = walk_state
			
	elif anim_name == "attack2":
		if attacking:
			playback.travel(attack_animations[2])
		else:
			next_state = walk_state
		
	elif anim_name == "attack3":
		attacking = false
		next_state = walk_state
