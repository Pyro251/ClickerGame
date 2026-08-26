extends ColorRect


func _ready() -> void:
	Global.refresh_theme.connect(refresh_theme)
	
	refresh_theme()

func refresh_theme():
	color = Global.main_color
