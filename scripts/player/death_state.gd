extends State

class_name DeathState

@onready var reload_timer: Timer = $"../../ReloadTimer"

@export var death_animation_name : String = "death"


func on_enter():
	reload_timer.start()
	character.velocity = Vector2.ZERO
	
	character.set_collision_layer(0)


func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
