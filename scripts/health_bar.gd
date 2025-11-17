extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

@export var player : Player

var damageable : Damageable


func _ready():
	damageable = player.get_node("Damageable")

	texture_progress_bar.max_value = damageable.health
	texture_progress_bar.value = damageable.health
	
	SignalBus.connect("on_health_changed", _on_health_changed)

func _on_health_changed(node : Node, _amount_changed : int):
	print("on_health_changed -> node:", node, "amount:", _amount_changed, "player==node?", node == player, "health:", damageable.health)
	
	if node == player:
		texture_progress_bar.value = damageable.health
