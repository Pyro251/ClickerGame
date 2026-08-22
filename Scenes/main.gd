extends TaloLoadable



@onready var player_name_label: Label = $PlayerNameLabel
@onready var clicks_label: Label = $TotalClicksLabel
@onready var prestige_label: Label = $PrestigeLabel
@onready var save_game_label: Label = $SaveGameLabel

@onready var add_click_button: Button = $ClickButton

@onready var prestige_progress_bar: ProgressBar = $PrestigeProgressBar

@onready var game_saved_timer: Timer = $GameSavedTimer


func _ready() -> void:
	
	Global.game_saved.connect(game_saved)
	
	Global.total_clicks = int(Talo.current_player.get_prop("total_clicks"))
	Global.money_multiplier = int(Talo.current_player.get_prop("money_multiplier"))
	
	
	Global.prestige_weight = (log(Global.total_clicks) / log(10)) / (Global.money_multiplier / 8)
	Global.prestige_progress = int((Global.prestige_weight - floor(Global.prestige_weight)) * 100)
	Global.new_money_multiplier = Global.money_multiplier + floor(int(Global.prestige_weight))
	
	player_name_label.text = Global.username
	prestige_label.text = str("Prestige Points: ", int(Global.new_money_multiplier - Global.money_multiplier))
	
	prestige_progress_bar.value = Global.prestige_progress



func _process(delta: float) -> void:
	clicks_label.text = str(Global.total_clicks)



func register_fields() -> void:
	register_field("total_clicks", Global.total_clicks)

func on_loaded(data: Dictionary) -> void:
	Global.total_clicks = data.get("total_clicks", 0)


func game_saved():
	save_game_label.text = "Game Saved!"


func _on_click_button_pressed() -> void:
	Global.total_clicks += int(1 * Global.money_multiplier)
	Global.prestige_weight = (log(Global.total_clicks) / log(10)) / (Global.money_multiplier / 8)
	Global.prestige_progress = int((Global.prestige_weight - floor(Global.prestige_weight)) * 100)
	Global.new_money_multiplier = Global.money_multiplier + floor(int(Global.prestige_weight))
	
	prestige_label.text = str("Prestige Points: ", int(Global.new_money_multiplier - Global.money_multiplier))
	prestige_progress_bar.value = Global.prestige_progress
	
	print("Prestige Weight: ", Global.prestige_weight)
	print("Prestige Progress: ", Global.prestige_progress)
	print("Total clicks: ", Global.total_clicks)



func _on_manuel_save_button_pressed() -> void:
	print("Manuel save button pressed.")
	save_game_label.show()
	save_game_label.text = "Saving game...."
	game_saved_timer.start()
	Global.save_game()


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/leaderboard.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_shop.tscn")


func _on_game_saved_timer_timeout() -> void:
	save_game_label.hide()
