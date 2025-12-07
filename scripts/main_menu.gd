extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings_menu: Panel = $SettingsMenu
@onready var click_audio: AudioStreamPlayer = $ClickAudio

@export var is_pause_menu := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	settings_menu.visible = false
	
	# MENU PRINCIPAL: tenta focar o botão Play
	if not is_pause_menu:
		var play_button = get_node_or_null("MainButtons/Play")
		if play_button:
			play_button.grab_focus()
	else:
		# PAUSE MENU: foca o botão Continue
		var continue_button = get_node_or_null("MainButtons/Continue")
		if continue_button:
			continue_button.grab_focus()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	click_audio.play()	
	
	if is_pause_menu:
		get_tree().paused = false
		visible = false
	else:
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
