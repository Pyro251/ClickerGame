extends Control


@onready var validation_label: Label = $VBoxContainer/ValidationLabel
@onready var typing_sounds: AudioStreamPlayer = $TypingSounds
@onready var password_line_edit: LineEdit = $VBoxContainer/HBoxContainer/PasswordLineEdit
@onready var show_password_texture_button: TextureButton = $VBoxContainer/HBoxContainer/ShowPasswordTextureButton

const VIEW_ICON = preload("res://assets/CleanIconPack/view.png")
const X_ICON = preload("res://assets/CleanIconPack/x.png")

var can_find_session: bool = true


func _on_submit_button_pressed() -> void:
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
		return

	# Talo automatically authenticates the session on successful registration
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_username_line_edit_text_changed(new_text: String) -> void:
	Global.username = new_text
	typing_sounds.play()


func _on_password_line_edit_text_changed(new_text: String) -> void:
	Global.password = new_text
	typing_sounds.play()


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


func _on_show_password_texture_button_pressed() -> void:
	if password_line_edit.secret:
		password_line_edit.secret = false
		show_password_texture_button.texture_normal = X_ICON
		show_password_texture_button.texture_hover = X_ICON
		show_password_texture_button.texture_pressed = X_ICON
	else:
		password_line_edit.secret = true
		show_password_texture_button.texture_normal = VIEW_ICON
		show_password_texture_button.texture_hover = VIEW_ICON
		show_password_texture_button.texture_pressed = VIEW_ICON
