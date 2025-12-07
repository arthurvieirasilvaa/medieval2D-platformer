extends Area2D

@onready var ruby_collected_sfx: AudioStreamPlayer = $RubyCollectedSFX

@export var value : int = 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		
		tween.tween_property(self, "position", position + Vector2(0, -20), 0.3)
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		
		RubiesController.ruby_collected(value)
		
		ruby_collected_sfx.play()

		tween.tween_callback(self.queue_free)
