extends Node

const USEROPTIONS = "user://user_options.save";
const LASTCONNECTION = "user://last_connection.save";

var userOptions_data = {}
var last_connection = {}

func _ready():
	userOptions_data = get_userOptions()
	last_connection = get_lConnection()
	await get_tree().create_timer(1.0).timeout
	ready.emit()

func get_userOptions():
	if !FileAccess.file_exists(USEROPTIONS):
		userOptions_data = {"User_login": "", "User_password": ""}
		save_userOptions()
	var file = FileAccess.open(USEROPTIONS, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	userOptions_data = data
	file.close()
	return data

func save_userOptions():
	var save_userOptions = FileAccess.open(USEROPTIONS, FileAccess.WRITE)
	save_userOptions.store_line(JSON.stringify(userOptions_data))
	save_userOptions.close()

func get_lConnection():
	if !FileAccess.file_exists(LASTCONNECTION):
		last_connection = {"address": "127.0.0.1", "port": 4242}
		save_lConnection()
	var file = FileAccess.open(LASTCONNECTION, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	last_connection = data
	return data

func save_lConnection():
	var save_connection = FileAccess.open(LASTCONNECTION, FileAccess.WRITE)
	save_connection.store_line(JSON.stringify(last_connection))
	save_connection.close()

func gen_sha(str: String):
	return str.sha256_text()
