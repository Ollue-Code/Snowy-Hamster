extends MultiplayerSpawner

@export var network_player : PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
		
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).add_child(player)
	
	while not player.is_inside_tree():
		await get_tree().process_frame


func _on_peer_disconnected(id: int) -> void:
	var parent = get_node_or_null(spawn_path)
	if not parent:
		return
	var player = parent.get_node_or_null(str(id))
	if player:
		player.queue_free()
