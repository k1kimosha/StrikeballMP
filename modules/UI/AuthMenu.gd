extends CenterContainer

@onready var login = $VBoxContainer/HBoxContainer/LoginTextBox;
@onready var password = $VBoxContainer/HBoxContainer/PasswordTextBox;
@onready var MainMenu = $"../MainMenu"

var debug_login = "test";
var debug_password = "123";

func _ready():
	login.text = Save.userOptions_data["User_login"]
	password.text = Save.userOptions_data["User_password"]

func _on_auth_button_pressed():
	if Save.userOptions_data["User_login"] == debug_login and Save.userOptions_data["User_password"] == debug_password:
		hide()
		MainMenu.show()

func _on_login_text_box_text_changed(new_text):
	Save.userOptions_data["User_login"] = new_text
	Save.save_userOptions()

func _on_password_text_box_text_changed(new_text):
	Save.userOptions_data["User_password"] = new_text
	Save.save_userOptions()
