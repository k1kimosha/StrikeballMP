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
		userOptions_data = {
			"User_login": "",
			"User_password": "",
			"User_name": "unknown",
		}
		
		save_userOptions()
	
	var file = FileAccess.open(USEROPTIONS, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	userOptions_data = data
	file.close()
	return data

func save_userOptions():
	var _save_userOptions = FileAccess.open(USEROPTIONS, FileAccess.WRITE)
	_save_userOptions.store_line(JSON.stringify(userOptions_data))
	_save_userOptions.close()

func get_lConnection():
	if !FileAccess.file_exists(LASTCONNECTION):
		last_connection = {
			"address": "127.0.0.1",
			"port": 4242
		}
		
		save_lConnection()
	
	var file = FileAccess.open(LASTCONNECTION, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	last_connection = data
	return data

func save_lConnection():
	var _save_lConnection = FileAccess.open(LASTCONNECTION, FileAccess.WRITE)
	_save_lConnection.store_line(JSON.stringify(last_connection))
	_save_lConnection.close()

func gen_sha(_str: String):
	return _str.sha256_text()
