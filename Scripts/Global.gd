extends Node

signal update_clicks(clicks: int)
signal save_game_signal
signal game_saved


func _ready() -> void:
	load_game()

const lboard_name: String = "clicker_game_lboard"


var total_clicks: int = 0
var money_multiplier: float = 1.0
var new_money_multiplier: int = 0
#var prestige_weight: float = floor(log(total_clicks) / log(10))
var prestige_weight: float = 0.0
var prestige_progress: float = 0.0


var player_name: String = str("Player ", str(randi_range(1, 999)))
var username: String
var password: String

var save_name: String = "save_name"



func save_game():
	await Talo.current_player.set_prop("total_clicks", str(Global.total_clicks))
	print("total_clicks prop set to: ", Talo.current_player.get_prop("total_clicks"))
	
	await Talo.current_player.set_prop("money_multiplier", str(Global.money_multiplier))
	
	print("game saved")
	await update_leaderboard()
	
	game_saved.emit()

func load_game():
	pass

func update_leaderboard():
	var metadata: Dictionary[String, Variant] = {
		"username": username
	}
	var res = await Talo.leaderboards.add_entry(lboard_name, total_clicks, metadata)
	print("Added score: %s, at position: %s, new high score: %s" % [Global.total_clicks, res.entry.position, "yes" if res.updated else "no"])
#func register_fields():
	#register_field("total_clicks", total_clicks)
#
#func create_save():
	#Talo.saves.create_save(save_name, save_data)
#
#func update_save():
	#Talo.saves.update_save()
