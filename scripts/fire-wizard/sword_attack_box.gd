extends Area2D

@export var damage : int = 10
@export var fire_wizard : FireWizard
@export var facing_shape : FacingCollisionShape2D


func _ready() -> void:
	monitoring = false
	fire_wizard.connect("facing_direction_changed", _on_fire_wizard_direction_changed)


func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is Damageable:
			# Obtém a direção da espada para o corpo:
			var direction_to_damageable = body.global_position - get_parent().global_position
			var direction_sign = sign(direction_to_damageable.x)
			
			if direction_sign > 0:
				child.hit(damage, Vector2.RIGHT)
			elif direction_sign < 0:
				child.hit(damage, Vector2.LEFT)
			else:
				child.hit(damage, Vector2.ZERO)


func _on_fire_wizard_direction_changed(facing_right : bool):
	if facing_right:
		facing_shape.position = facing_shape.facing_right_position
	else:
		facing_shape.position = facing_shape.facing_left_position
