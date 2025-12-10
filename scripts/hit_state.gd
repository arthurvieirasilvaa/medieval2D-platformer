extends State

class_name HitState

@onready var timer: Timer = $Timer

@export var damageable : Damageable
@export var death_state : State
@export var hurt_animation_node : String = "hurt"
@export var death_animation_node : String = "death"
@export var knockback_speed : float = 100.0
@export var return_state : State

var return_animation_name : String = "move"


func _ready():
	damageable.connect("on_hit", on_damageable_hit)


func on_enter():	
	timer.start()


func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if damageable.health > 0:
		character.velocity = knockback_speed * knockback_direction
		playback.travel(hurt_animation_node)
		timer.start()
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", death_state)
		playback.travel(death_animation_node)


func on_exit():
	character.velocity = Vector2.ZERO


func _on_timer_timeout() -> void:
	next_state = return_state
	playback.travel(return_animation_name)
