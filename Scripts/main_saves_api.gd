extends SavesAPI


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#Global.save_game_signal.connect(save_game)
	#
	#



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func save_game():
	#Talo.current_player.set_prop("total_clicks", str(Global.total_clicks))
	#print("total_clicks prop set to: ", Talo.current_player.get_prop("total_clicks"))
	#print("game saved")
	#
	#print("saving game...")
	#if await Talo.saves.get_saves() == null:
		#Talo.saves.create_save("save")
		#print("New save created.")
	#else:
		#await Talo.saves.update_save()
