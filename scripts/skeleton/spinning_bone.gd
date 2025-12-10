extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 100
@export var damage_amount : int = 5

var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * direction


func set_direction(skeleton_direction):
	
	direction = skeleton_direction
	animation.flip_h = direction < 0


func _on_self_destruct_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Hitbox"):
		print("ENTROU")
		var player = area.get_parent()
		
		if player is Player:
			var knockback_direction = (player.global_position - global_position).normalized()
			
			player.damageable.hit(damage_amount, -knockback_direction)
		
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
