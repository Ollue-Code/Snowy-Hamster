extends MultiplayerSpawner

@export var network_player : PackedScene

var player_colours: Array = []

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
		
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
	
	while not player.is_inside_tree():
		await get_tree().process_frame

@rpc("any_peer", "call_local")
func set_player_colours(main_colour,main_band_colour,right_band_colour,left_band_colour) -> void:
	var id = multiplayer.get_remote_sender_id()
	var found = false
	for player in player_colours: #find the player info
		if player[0] == id: #find the player with the associated id in the player colour list
			player[1] = main_colour 
			player[2] = main_band_colour
			player[3] = right_band_colour
			player[4] = left_band_colour
			found = true
			break
	if not found:
		player_colours.append([id, main_colour,main_band_colour,right_band_colour,left_band_colour])

	manage_player_colours(id, main_colour,main_band_colour,right_band_colour,left_band_colour)
	

func manage_player_colours(id,main_colour,main_band_colour,right_band_colour,left_band_colour):
	if not multiplayer.is_server():
		return
	if id != 1:
		var player_node = get_node_or_null(spawn_path).get_node_or_null(str(id))
		if player_node:
			player_node.rpc("set_colours",main_colour,main_band_colour,right_band_colour,left_band_colour)

func _on_peer_disconnected(id: int) -> void:
	var parent = get_node_or_null(spawn_path)
	if not parent:
		return
	var player = parent.get_node_or_null(str(id))
	if player:
		player.queue_free()
