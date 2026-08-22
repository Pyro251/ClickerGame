extends TaloLoadable



func register_fields():
	register_field("total_clicks", Global.total_clicks)
	id = '1'
	#Not sure if setting the id to a random number works
	#id = str(randf_range(-9999999999999, 9999999999999))

func on_loaded(data: Dictionary) -> void:
	Global.total_clicks = data.get("total_clicks", 3)
