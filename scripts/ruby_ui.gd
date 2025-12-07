extends Control

@onready var label: Label = $Label


func _ready() -> void:
	SignalBus.connect("ruby_collected", on_event_ruby_collected)	


func on_event_ruby_collected(value : int) -> void:
	label.text = str(value)
