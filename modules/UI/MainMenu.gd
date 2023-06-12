extends CenterContainer

@onready var selected_address = $VBoxContainer/GridContainer/AddressTextBox;
@onready var selected_port = $VBoxContainer/GridContainer/PortTextBox;
@onready var server_not_exist = $"../Server_not_exist";

func _ready():
	selected_address.text = Save.last_connection["address"]
	selected_port.text = str(Save.last_connection["port"])

func _on_join_button_pressed():
	Save.last_connection["address"] = selected_address.text
	Save.last_connection["port"] = selected_port.text
	Save.save_lConnection()
	Signals.join_button_pressed.emit()

func show_server_not_exist():
	server_not_exist.show()
	await get_tree().create_timer(5).timeout
	server_not_exist.hide()
