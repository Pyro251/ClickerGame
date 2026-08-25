extends Node

signal update_clicks(clicks: int)
signal save_game_signal
signal game_saved


const lboard_name: String = "clicker_game_lboard"


var total_clicks: int = 0
var clicks_per_second: int = 0
var money_multiplier: int = 1
var new_money_multiplier: int = 0
#var prestige_weight: float = floor(log(total_clicks) / log(10))
var prestige_money_needed: int = 150
var prestige_progress: float = 0


var player_name: String = str("Player ", str(randi_range(1, 999)))
var username: String
var password: String

var save_name: String = "save_name"

var owned_items: Dictionary = {}

func _ready() -> void:
	
	Global.timer.connect("timeout", on_global_timer_timeout)
	
	make_global_timer(1, false)


func save_game():
	await Talo.current_player.set_prop("total_clicks", str(Global.total_clicks))
	print("total_clicks prop set to: ", Talo.current_player.get_prop("total_clicks"))
	
	await Talo.current_player.set_prop("money_multiplier", str(Global.money_multiplier))
	
	await Talo.current_player.set_prop("prestige_money_needed", str(Global.prestige_money_needed))
	
	await Talo.current_player.set_prop("clicks_per_second", str(Global.clicks_per_second))
	
	await Talo.current_player.set_prop("owned_items", str(owned_items))
	
	print("game saved")
	await update_leaderboard()
	
	game_saved.emit()

func load_game():
	pass

#func make_global_timer(time: float, money_earned: int, one_shot: bool = false):
	#var timer = Timer.new()
	#timer.autostart = true
	#timer.wait_time = time
	#timer.one_shot = one_shot
	#timer.set_script("res://Scripts/global_timer.gd")
	#timer.money_earned_when_done = money_earned
	#add_child(timer)

var timer = Timer.new()
func make_global_timer(time: float, one_shot: bool = false):
	
	timer.autostart = true
	timer.wait_time = time
	timer.one_shot = one_shot
	add_child(timer)


func on_global_timer_timeout():
	total_clicks += clicks_per_second
	update_clicks.emit(clicks_per_second)

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
