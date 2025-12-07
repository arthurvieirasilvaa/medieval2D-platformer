extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings_menu: Panel = $SettingsMenu
@onready var click_audio: AudioStreamPlayer = $ClickAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	settings_menu.visible = false
	get_node("MainButtons/Play").grab_focus()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	click_audio.play()	
	get_tree().change_scene_to_file("res://scene/forest.tscn")


func _on_settings_pressed() -> void:
	click_audio.play()
	main_buttons.visible = false
	settings_menu.visible = true


func _on_quit_pressed() -> void:
	click_audio.play()
	get_tree().quit()


func _on_back_pressed() -> void:
	click_audio.play()
	_ready()
