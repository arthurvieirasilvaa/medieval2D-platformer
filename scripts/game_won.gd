extends Control

@onready var click_audio: AudioStreamPlayer = $ClickAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var play_again_button = get_node_or_null("Play again")
	if play_again_button:
		play_again_button.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	click_audio.play()
	get_tree().change_scene_to_file("res://scene/forest.tscn")
