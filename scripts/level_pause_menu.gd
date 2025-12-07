extends Node2D

@onready var pause_menu: Control = $PauseMenu/PauseMenu


func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause_menu()


func toggle_pause_menu():
	if pause_menu.visible:
		# Desativar pause
		pause_menu.visible = false
		get_tree().paused = false
	else:
		# Ativar pause
		pause_menu.visible = true
		get_tree().paused = true
