extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var timer: Timer = $Timer

@export var return_state : State
@export var return_animation_node : String = "move"
@export var attack_name : String = "attack"
@export var combo_attack_name : String = "combo_attack"


func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		timer.start()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == attack_name:
		if timer.is_stopped():
			next_state = return_state
			playback.travel(return_animation_node)
		else:
			playback.travel(combo_attack_name)
	
	if anim_name == combo_attack_name:
		next_state = return_state
		playback.travel(return_animation_node)
