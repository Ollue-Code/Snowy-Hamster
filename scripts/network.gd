extends Node

const PORT: int = 60000

var peer: ENetMultiplayerPeer

func start_server():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		printerr("ERROR: Failed to create server. Error code: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)

func start_client(raw_address: String):
	var host := raw_address
	var port := PORT

	if raw_address.find(":") != -1:
		var parts = raw_address.split(":")
		host = parts[0]
		port = int(parts[1])
	else:
		host = raw_address

	print("Client connecting to ", host, ":", port)

	peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(host, port)

	if err != OK:
		print("ERROR: Could not connect. Code: ", err)
		return

	multiplayer.multiplayer_peer = peer
	print("Client connected (request sent).")
