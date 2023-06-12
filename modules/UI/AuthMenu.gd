extends CenterContainer

@onready var login = $VBoxContainer/HBoxContainer/LoginTextBox;
@onready var password = $VBoxContainer/HBoxContainer/PasswordTextBox;
@onready var user_not_exist = $"../User_not_exist";
@onready var MainMenu = $"../MainMenu";
@onready var http_request = HTTPRequest.new();

var debug_login = "test";
var debug_password = "123".sha256_text();

func _ready():
	login.text = Save.userOptions_data["User_login"]
	password.text = Save.userOptions_data["User_password"]
	add_child(http_request)
	http_request.request_completed.connect(self._on_request_completed)

func _on_auth_button_pressed():
	var password_sha256 = Save.gen_sha(password.text)
	var json = JSON.stringify({
		"login": login.text,
		"password": password_sha256
	})
	var headers = ["Content-Type: application/json"]
	http_request.request("http://127.0.0.1:3000/api/login", headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(_result, _response_code, _headers, _body: PackedByteArray):
	if _response_code == 200:
		var json = JSON.parse_string(_body.get_string_from_utf8())
		Save.userOptions_data["User_name"] = json["User_name"]
		Save.userOptions_data["User_login"] = login.text
		Save.userOptions_data["User_password"] = password.text
		Save.save_userOptions()
		hide()
		MainMenu.show()
	else:
		self._show_user_not_exist()

func _show_user_not_exist():
	user_not_exist.show()
	await get_tree().create_timer(5.0).timeout
	user_not_exist.hide()
