extends Node2D

@export var heart1 : Texture2D
@export var heart0 : Texture2D

@onready var heart_1 = $Heart1
@onready var heart_2 = $Heart2
@onready var heart_3 = $Heart3

func _ready():
	SignalBus.on_health_changed.connect(_on_health_changed)


func _on_health_changed(node, amount_changed):
	# Só atualiza se for o Player
	if not node.is_in_group("Player"):
		return

	# Aqui pegamos o health atual REAL do player
	var player_current_health = node.get_node("Damageable").health	
	
	if player_current_health >= 20:
		heart_3.texture = heart1
	else:
		heart_3.texture = heart0
	
	if player_current_health >= 10:
		heart_2.texture = heart1
	else:
		heart_2.texture = heart0
	
	if player_current_health >= 0:
		heart_1.texture = heart1
	else:
		heart_1.texture = heart0
