extends Control


@onready var validation_label: Label = $VBoxContainer/ValidationLabel

var can_find_session: bool = true


func _on_submit_button_pressed() -> void:
	#Talo.player_auth.register(Global.username, Global.password)
	
	var res = await Talo.player_auth.register(Global.username, Global.password)
	if res != OK:
		validation_label.show()
		match Talo.player_auth.last_error.get_code():
			TaloAuthError.ErrorCode.IDENTIFIER_TAKEN:
				validation_label.text = "Username is already taken"
			TaloAuthError.ErrorCode.IDENTIFIER_PROFANITY:
				validation_label.text = "Username contains profanity"
			TaloAuthError.ErrorCode.NEW_PASSWORD_MATCHES_CURRENT_PASSWORD:
				validation_label.text = "New password matches current one."
			_:
				validation_label.text = Talo.player_auth.last_error.get_string()
	
	if !TaloAuthError:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_username_line_edit_text_changed(new_text: String) -> void:
	Global.username = new_text


func _on_password_line_edit_text_changed(new_text: String) -> void:
	Global.password = new_text


func _on_log_in_button_pressed() -> void:
	var res := await Talo.player_auth.login(Global.username, Global.password)
	match res:
		Talo.player_auth.LoginResult.FAILED:
			validation_label.show()
			match Talo.player_auth.last_error.get_code():
				TaloAuthError.ErrorCode.INVALID_CREDENTIALS:
					validation_label.text = "Username or password is incorrect"
				_:
					validation_label.text = Talo.player_auth.last_error.get_string()
		#Talo.player_auth.LoginResult.VERIFICATION_REQUIRED:
			#verification_required.emit()
		Talo.player_auth.LoginResult.OK:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_dev_log_in_button_pressed() -> void:
	Global.username = "Caiden"
	Global.password = "Caiden"
	var res := await Talo.player_auth.login("Caiden", "Caiden")
	match res:
		Talo.player_auth.LoginResult.FAILED:
			validation_label.show()
			match Talo.player_auth.last_error.get_code():
				TaloAuthError.ErrorCode.INVALID_CREDENTIALS:
					validation_label.text = "Username or password is incorrect"
				_:
					validation_label.text = Talo.player_auth.last_error.get_string()
		#Talo.player_auth.LoginResult.VERIFICATION_REQUIRED:
			#verification_required.emit()
		Talo.player_auth.LoginResult.OK:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
