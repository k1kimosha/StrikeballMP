extends CenterContainer

@onready var login = $VBoxContainer/HBoxContainer/LoginTextBox;
@onready var password = $VBoxContainer/HBoxContainer/PasswordTextBox;
@onready var MainMenu = $"../MainMenu"

var debug_login = "test";
var debug_password = "123".sha256_text();

func _ready():
	login.text = Save.userOptions_data["User_login"]
	password.text = Save.userOptions_data["User_password"]

func _on_auth_button_pressed():
	var password_sha256 = Save.gen_sha(password.text)
	if login.text == debug_login and password_sha256 == debug_password:
		Save.userOptions_data["User_login"] = login.text
		Save.userOptions_data["User_password"] = password.text
		Save.save_userOptions()
		hide()
		MainMenu.show()
