extends Node

var total_rubies : int = 0

func ruby_collected(value : int):
	total_rubies += value
	SignalBus.emit_signal("ruby_collected", total_rubies)
