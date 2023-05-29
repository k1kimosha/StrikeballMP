extends Node

const USEROPTIONS = "user://user_options.save";
const SAVEGAME = "user://save_game.save";

var userOptions_data = {}
var save_data = {}

func _ready():
	userOptions_data = get_userOptions()
	save_data = get_game()
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

func get_game():
	if !FileAccess.file_exists(SAVEGAME):
		save_data = {"address": "127.0.0.1", "port": 4242}
		save_game()
	var file = FileAccess.open(SAVEGAME, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	save_data = data
	return data

func save_game():
	var save_game = FileAccess.open(SAVEGAME, FileAccess.WRITE)
	save_game.store_line(JSON.stringify(save_data))
	save_game.close()
