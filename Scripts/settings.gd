extends Control



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_sign_out_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sign_in_screen.tscn")


func _on_send_feedback_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/feedback_menu.tscn")
