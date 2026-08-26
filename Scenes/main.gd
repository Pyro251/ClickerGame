extends TaloLoadable

const MONEY_COUNTER_PARTICLE = preload("res://Scenes/money_counter_particle.tscn")
const PANEL_STYLES = preload("res://resources/Panels/top_panel.tres")

@onready var player_name_label: Label = $PlayerNameLabel
@onready var clicks_label: Label = $TotalClicksLabel
@onready var prestige_label: Label = $PrestigeLabel
@onready var save_game_label: Label = $SaveGameLabel

@onready var add_click_button: Button = $ClickButton

@onready var prestige_progress_bar: ProgressBar = $PrestigeProgressBar

@onready var game_saved_timer: Timer = $GameSavedTimer

@onready var top_background: Panel = $TopBackground
@onready var bottom_background: Panel = $BottomBackground

func _ready() -> void:
	
	if Talo.current_player.get_prop("total_clicks") == null:
		await Talo.current_player.set_prop("total_clicks", "0")
	
	if Talo.current_player.get_prop("money_multiplier") == null:
		await Talo.current_player.set_prop("money_multiplier", "0")
	
	if Talo.current_player.get_prop("prestige_money_needed") == null:
		await Talo.current_player.set_prop("prestige_money_needed", "0")
	
	if Talo.current_player.get_prop("clicks_per_second") == null:
		await Talo.current_player.set_prop("clicks_per_second", "0")
	
	if Talo.current_player.get_prop("main_color") == null:
		await Talo.current_player.set_prop("main_color", str(Global.main_color))
	
	if Talo.current_player.get_prop("accent_color") == null:
		await Talo.current_player.set_prop("accent_color", str(Global.accent_color))
	
	if Talo.current_player.get_prop("button_color") == null:
		await Talo.current_player.set_prop("button_color", str(Global.button_color))
	
	if Talo.current_player.get_prop("owned_items") == null:
		await Talo.current_player.set_prop("owned_items", "")
	
		print("Set 'owned_items' to ''")
	if Talo.current_player.get_prop("owned_themes") == null:
		await Talo.current_player.set_prop("owned_themes", "")
		print("Set 'owned_themes' to ''")
	
	if Talo.current_player.get_prop("selected_theme") == null:
		await Talo.current_player.set_prop("selected_theme", "")
		print("Set 'selected_theme' to ''")
	
	
	Global.update_clicks.connect(update_clicks)
	
	Global.game_saved.connect(game_saved)
	
	
	Global.username = Talo.current_alias.identifier
	Global.total_clicks = int(Talo.current_player.get_prop("total_clicks"))
	Global.money_multiplier = int(Talo.current_player.get_prop("money_multiplier"))
	Global.clicks_per_second = int(Talo.current_player.get_prop("clicks_per_second"))
	
	
	var main_raw_color_string = Talo.current_player.get_prop("main_color")
	var main_parsed_color: Color = str_to_var("Color" + main_raw_color_string)
	
	Global.main_color = main_parsed_color
	
	var accent_raw_color_string = Talo.current_player.get_prop("accent_color")
	var accent_parsed_color: Color = str_to_var("Color" + accent_raw_color_string)
	
	Global.accent_color = accent_parsed_color
	
	var raw_color_string = Talo.current_player.get_prop("button_color")
	var parsed_color: Color = str_to_var("Color" + raw_color_string)
	
	Global.button_color = parsed_color
	
	if Talo.current_player.get_prop("owned_items") != "":
		var items_raw_string: String = Talo.current_player.get_prop("owned_items")
		Global.owned_items = JSON.parse_string(items_raw_string)
	if Talo.current_player.get_prop("owned_themes") != "":
		var themes_raw_string: String = Talo.current_player.get_prop("owned_themes")
		Global.owned_themes = JSON.parse_string(themes_raw_string)
	if Talo.current_player.get_prop("selected_theme") != "":
		var selected_themes_raw_string: String = Talo.current_player.get_prop("selected_theme")
		Global.selected_theme = JSON.parse_string(selected_themes_raw_string)
	
	
	Global.new_money_multiplier = Global.money_multiplier + 1
	
	
	player_name_label.text = Global.username
	prestige_label.text = str("Prestige Points: ", int(Global.new_money_multiplier - Global.money_multiplier))
	
	if Global.total_clicks <= Global.prestige_money_needed:
		prestige_label.text = str("Money until next prestige: ", Global.prestige_money_needed - Global.total_clicks)
	else:
		prestige_label.text = "You can prestige!"
	
	prestige_progress_bar.max_value = Global.prestige_money_needed
	prestige_progress_bar.value = Global.total_clicks
	
	
	print("Money multiplier = ", Global.money_multiplier)
	
	Global.refresh_theme.emit()
	
	Global.change_labels_font_color(self, Global.button_color)



func _process(delta: float) -> void:
	clicks_label.text = str(Global.total_clicks, "$")


func update_clicks(clicks: int):
	var new_money_counter = MONEY_COUNTER_PARTICLE.instantiate()
	new_money_counter.clicks = clicks
	new_money_counter.global_position = $TotalClicksLabel/ParticleSpawnMarker.global_position
	add_child(new_money_counter)
	
	prestige_progress_bar.value = Global.total_clicks


func register_fields() -> void:
	register_field("total_clicks", Global.total_clicks)

func on_loaded(data: Dictionary) -> void:
	Global.total_clicks = data.get("total_clicks", 0)


func game_saved():
	save_game_label.text = "Game Saved!"


func _on_click_button_pressed() -> void:
	Global.update_clicks.emit(int(1 * Global.money_multiplier))
	
	Global.total_clicks += int(1 * Global.money_multiplier)
	
	if Global.total_clicks <= Global.prestige_money_needed:
		prestige_label.text = str("Money until next prestige: ", Global.prestige_money_needed - Global.total_clicks)
	else:
		prestige_label.text = "You can prestige!"
	
	prestige_progress_bar.value = Global.total_clicks
	
	Input.vibrate_handheld(3, 50)
	
	
	#print("Prestige Weight: ", Global.prestige_weight)
	print("Prestige Progress: ", Global.prestige_progress)
	print("Total clicks: ", Global.total_clicks)



func _on_manuel_save_button_pressed() -> void:
	print("Manuel save button pressed.")
	save_game_label.show()
	save_game_label.text = "Saving game...."
	game_saved_timer.start()
	Global.save_game()


func _on_leaderboard_button_pressed() -> void:
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/leaderboard.tscn")


func _on_settings_button_pressed() -> void:
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_shop_button_pressed() -> void:
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/main_shop.tscn")


func _on_game_saved_timer_timeout() -> void:
	save_game_label.hide()
