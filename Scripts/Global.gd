extends Node

signal update_clicks(clicks: int)
signal save_game_signal
signal game_saved
signal update_selected_theme
signal refresh_theme

const lboard_name: String = "clicker_game_lboard"


var total_clicks: int = 0
var clicks_per_second: int = 0
var money_multiplier: int = 1
var new_money_multiplier: int = 0
#var prestige_weight: float = floor(log(total_clicks) / log(10))
var prestige_money_needed: int = 150
var prestige_progress: float = 0

var main_color: Color = Color(0.98, 0.929, 0.804, 1.0)
var accent_color: Color = Color(0.8, 0.835, 0.682, 1.0)
var button_color: Color = Color(0.831, 0.639, 0.451, 1.0)

var player_name: String = str("Player ", str(randi_range(1, 999)))
var username: String
var password: String

var save_name: String = "save_name"

var owned_items: Dictionary = {}
var owned_themes: Dictionary = {}
var selected_theme: Dictionary = {}

func _ready() -> void:
	
	Global.timer.connect("timeout", on_global_timer_timeout)
	
	
	make_global_timer(1, false)

func change_labels_font_color(node: Node, color: Color):
	for child in node.get_children():
		if child is Label:
			child.add_theme_color_override("font_color", color)
		if child.get_child_count() > 0:
			change_labels_font_color(child, color)

func set_theme(main: Color, accent: Color, button: Color):
	main_color = main
	accent_color = accent
	button_color = button

func save_game():
	await Talo.current_player.set_prop("total_clicks", str(Global.total_clicks))
	print("total_clicks prop set to: ", Talo.current_player.get_prop("total_clicks"))
	
	await Talo.current_player.set_prop("money_multiplier", str(Global.money_multiplier))
	
	await Talo.current_player.set_prop("prestige_money_needed", str(Global.prestige_money_needed))
	
	await Talo.current_player.set_prop("clicks_per_second", str(Global.clicks_per_second))
	
	await Talo.current_player.set_prop("owned_items", str(owned_items))
	
	await Talo.current_player.set_prop("selected_theme", str(selected_theme))
	
	await Talo.current_player.set_prop("main_color", str(main_color))
	
	await Talo.current_player.set_prop("accent_color", str(accent_color))
	
	await Talo.current_player.set_prop("button_color", str(button_color))
	
	print("game saved")
	await update_leaderboard()
	
	game_saved.emit()

func load_game():
	pass

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
