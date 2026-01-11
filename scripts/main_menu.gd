extends Node2D

@onready var join: Button = $Control/VBoxContainer/Join
@onready var host: Button = $Control/VBoxContainer/Host

@onready var ip_popup: PopupPanel = $IP_Popup
@onready var ip_field: LineEdit = $"IP_Popup/VBoxContainer/IP field"

@onready var main: ColorRect = $Control/Colour_Pickers/Player_Preview/Colour/Main
@onready var right_band: ColorRect = $Control/Colour_Pickers/Player_Preview/Colour/Right_Band
@onready var left_band: ColorRect = $Control/Colour_Pickers/Player_Preview/Colour/Left_Band
@onready var main_band: ColorRect = $Control/Colour_Pickers/Player_Preview/Colour/Main_Band

func get_local_lan_ip() -> String:
	for addr in IP.get_local_addresses():
		if "." in addr and not ":" in addr \
		and not addr.begins_with("127.") \
		and not addr.begins_with("169.254."):
			return addr
	return "No LAN IP"


func _on_join_pressed() -> void:
	ip_popup.popup()

func _on_host_pressed() -> void:
	print(get_local_lan_ip())
	Network.start_server()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_ip_field_text_submitted(address: String) -> void:
	if IP.get_local_addresses().has(address):
		address = "127.0.0.1"
		print("Using loopback")

	Network.start_client(address)
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_main_color_changed(color: Color) -> void:
	Local_Global.main_colour = color
	main.color = Local_Global.main_colour

func _on_main_band_color_changed(color: Color) -> void:
	Local_Global.main_band_colour = color
	main_band.color = Local_Global.main_band_colour

func _on_right_band_color_changed(color: Color) -> void:
	Local_Global.right_band_colour = color
	right_band.color = Local_Global.right_band_colour

func _on_left_band_color_changed(color: Color) -> void:
	Local_Global.left_band_colour = color
	left_band.color = Local_Global.left_band_colour
