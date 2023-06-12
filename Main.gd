extends Node

@onready var player = preload("res://modules/player/player.tscn");
@onready var world = preload("res://modules/world/world.tscn");
@onready var UI = preload("res://modules/UI/UI.tscn");

func _ready():
	if "--server" in OS.get_cmdline_args():
		start_server(true)
	else:
		Save.ready.connect(load_ui)
		Signals.join_button_pressed.connect(join_button_pressed)
		discord_sdk.app_id = 1112393958920826900;
		discord_sdk.details = "Главное меню";
		discord_sdk.large_image = "logo";
		discord_sdk.start_timestamp = int(Time.get_unix_time_from_system());
		discord_sdk.refresh();

func load_ui():
	var ui = UI.instantiate()
	add_child(ui)

func join_button_pressed():
	var w = world.instantiate();
	add_child(w);
	start_server(false)

func start_server(server: bool):
	var peer = ENetMultiplayerPeer.new();
	
	if server:
		multiplayer.peer_connected.connect(self.peer_connected);
		multiplayer.peer_disconnected.connect(self.peer_disconected);
		
		peer.create_server(4242);
		print("server started on 4242");
	else:
		multiplayer.connected_to_server.connect(self.on_connect)
		multiplayer.connection_failed.connect(self.on_connection_failed)
		
		peer.create_client(Save.last_connection["address"], str(Save.last_connection["port"]).to_int());
		
	multiplayer.multiplayer_peer = peer;

func peer_connected(id: int):
	var p = player.instantiate();
	print(id, " has connected")
	
	p.name = str(id);
	$Players.add_child(p);

func peer_disconected(id: int):
	print(id, " has disconnected")
	$Players.get_node(str(id)).queue_free()

func on_connect():
	get_node("UI").hide()
	discord_sdk.details = "Тренирует стрельбу";
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system());
	discord_sdk.refresh();

func on_connection_failed():
	get_node("UI").get_node("MainMenu").show_unknow()
	
