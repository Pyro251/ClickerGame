extends Control


func _ready() -> void:
	%CheckBoxCleanClickerButton.button_pressed = Global.clean_clicker_button

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_sign_out_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sign_in_screen.tscn")


func _on_send_feedback_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/feedback_menu.tscn")


func _on_check_box_clean_clicker_button_pressed() -> void:
	Global.clean_clicker_button = !Global.clean_clicker_button
