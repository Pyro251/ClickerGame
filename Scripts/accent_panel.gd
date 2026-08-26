extends Panel


func _ready() -> void:
	
	Global.refresh_theme.connect(refresh_theme)
	
	refresh_theme()

func refresh_theme():
	var new_style: StyleBoxFlat= StyleBoxFlat.new()
	#var raw_color_string = Talo.current_player.get_prop("accent_color")
	#var parsed_color: Color = str_to_var("Color" + raw_color_string)
	
	new_style.bg_color = Global.accent_color
	
	new_style.corner_radius_bottom_left = 100
	new_style.corner_radius_bottom_right = 100
	new_style.corner_radius_top_left = 100
	new_style.corner_radius_top_right = 100
	
	new_style.shadow_size = 55
	
	add_theme_stylebox_override("panel", new_style)
