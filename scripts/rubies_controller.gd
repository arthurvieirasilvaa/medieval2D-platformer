extends Node

var total_rubies : int = 0

func _ready():
	SignalBus.emit_signal("ruby_collected", total_rubies)


func ruby_collected(value : int):
	total_rubies += value
	SignalBus.emit_signal("ruby_collected", total_rubies)


func reset_rubies():
	total_rubies = 0
	SignalBus.emit_signal("ruby_collected", total_rubies)
