extends CenterContainer

@onready var selected_address = $VBoxContainer/GridContainer/AddressTextBox;
@onready var selected_port = $VBoxContainer/GridContainer/PortTextBox;

func _ready():
	selected_address.text = Save.save_data["address"]
	selected_port.text = str(Save.save_data["port"])



func _on_join_button_pressed():
	Save.save_data["address"] = selected_address.text
	Save.save_data["port"] = selected_port.text
	Save.save_game()
	Signals.join_button_pressed.emit()
