extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 40.0
@export var max_health : float = 40.0
@export var death_animation_name : String = "death"


func hit(damage : int, knockback_direction : Vector2):
	var old_health = health
	health -= damage
	
	SignalBus.emit_signal("on_health_changed", get_parent(), -damage)
	emit_signal("on_hit", get_parent(), damage, knockback_direction)
	
	if health <= 0:
		pass


func heal(amount: int) -> bool:
	var old_health = health
	var new_health = min(health + amount, max_health)
	
	if new_health > old_health:
		var amount_healed = new_health - old_health
		health = new_health
	   
		SignalBus.emit_signal("on_health_changed", get_parent(), amount_healed)
		
		return true
		
	return false


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == death_animation_name:
		var owner = get_parent()
		
		if owner is Player:
			print("Player morreu, não liberar nó para permitir recarga.")
			return

		owner.queue_free()
