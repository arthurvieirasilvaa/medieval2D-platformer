extends Camera2D

var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_target()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = target.position # a posição da câmera é a mesma do player

func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	
	# Verifica se o player foi encontrado ao carregar a cena:
	if nodes.size() == 0:
		push_error("Player not found")
		return
	
	target = nodes[0]
