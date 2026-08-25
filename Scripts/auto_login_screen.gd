extends Control

@onready var description_label: Label = $DescriptionLabel

func _ready() -> void:
	Talo.player_auth.session_found.connect(session_found)
	Talo.player_auth.session_not_found.connect(session_not_found)
	Talo.players.identification_failed.connect(func(): print("Identification failed"))
	Talo.players.identification_started.connect(func(): print("Identification started"))
	Talo.players.identified.connect(player_identified)

func session_found():
	description_label.text = "Connecting to server"
	print("Session found!")

func session_not_found():
	print("Session not found.")
	get_tree().change_scene_to_file("res://Scenes/sign_in_screen.tscn")

func player_identified(_player: TaloPlayer):
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_log_in_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sign_in_screen.tscn")
