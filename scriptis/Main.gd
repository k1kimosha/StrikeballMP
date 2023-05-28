extends Node

@onready var player = preload("res://player.tscn");

func _enter_tree():
	if "--server" in OS.get_cmdline_args():
		start_server(true)
	else:
		start_server(false)
		discord_sdk.app_id = 1112393958920826900;
		discord_sdk.details = "Тренирует стрельбу";
		discord_sdk.large_image = "logo";
		discord_sdk.start_timestamp = int(Time.get_unix_time_from_system());
		discord_sdk.refresh();

func start_server(server: bool):
	var peer = ENetMultiplayerPeer.new();
	
	if server:
		multiplayer.peer_connected.connect(self.peer_connected);
		
		multiplayer.peer_disconnected.connect(self.peer_disconected);
		
		peer.create_server(4242);
		print("server started on 4242");
	else:
		peer.create_client("localhost", 4242);
	
	multiplayer.multiplayer_peer = peer;

func peer_connected(id: int):
	var p = player.instantiate();
	print(id, " has connected")
	
	p.name = str(id);
	$Players.add_child(p);

func peer_disconected(id: int):
	print(id, " has disconnected")
	$Players.get_node(str(id)).queue_free()
