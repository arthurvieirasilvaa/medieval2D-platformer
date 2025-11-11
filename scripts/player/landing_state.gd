extends State
class_name LandingState

@export var ground_state : State
@export var landing_animation : String = "landing"

func on_enter():
	playback.travel(landing_animation)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == landing_animation:
		next_state = ground_state
