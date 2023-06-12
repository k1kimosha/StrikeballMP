extends Node

@onready var player = preload("res://modules/player/player.tscn");
@onready var world = preload("res://modules/world/world.tscn");
@onready var UI = preload("res://modules/UI/UI.tscn");

var player_info = {};

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
	rpc_id(id, "register_player", player_info)

func peer_disconected(id: int):
	print(id, " has disconnected")
	player_info.erase(id)
	$Players.get_node(str(id)).queue_free()

func on_connect():
	get_node("UI").hide()
	discord_sdk.details = "Тренирует стрельбу";
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system());
	discord_sdk.refresh();

func on_connection_failed():
	get_node("UI").get_node("MainMenu").show_server_not_exist()

@rpc("any_peer")
func register_player(_player_info):
	var id = multiplayer.get_remote_sender_id()
	$Players.get_node(str(multiplayer.multiplayer_peer.get_unique_id())).get_node("username").text = Save.userOptions_data["User_name"];
	for _player in _player_info:
		$Players.get_node(str(_player)).get_node("username").text = _player_info[_player].username;
		rpc_id(_player, "register_on_other_client", Save.userOptions_data["User_name"])
	rpc_id(id, "register_on_server", Save.userOptions_data["User_name"]);

@rpc("any_peer")
func register_on_server(_username):
	var id = multiplayer.get_remote_sender_id();
	player_info[id] = {"username": _username};

@rpc("any_peer")
func register_on_other_client(_username):
	var id = multiplayer.get_remote_sender_id();
	$Players.get_node(str(id)).get_node("username").text = _username
