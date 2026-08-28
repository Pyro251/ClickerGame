extends TextureButton

var current_mode = DisplayServer.window_get_mode()

const MAXIMIZE_ICON = preload("res://assets/CleanIconPack/maximize.png")
const MINIMIZED_ICON = preload("res://assets/CleanIconPack/minimize.png")


func _on_pressed() -> void:
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		texture_normal = MAXIMIZE_ICON
		texture_hover = MAXIMIZE_ICON
		texture_pressed = MAXIMIZE_ICON
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		texture_normal = MINIMIZED_ICON
		texture_hover = MINIMIZED_ICON
		texture_pressed = MINIMIZED_ICON
