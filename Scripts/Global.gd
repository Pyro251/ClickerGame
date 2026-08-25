extends Node

signal update_clicks(clicks: int)
signal save_game_signal
signal game_saved


func _ready() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			(function() {
				if (document.getElementById('iosHapticToggle')) return;
				
				const haptic = document.createElement('input');
				haptic.type = 'checkbox';
				haptic.id = 'iosHapticToggle';
				haptic.setAttribute('switch', '');
				haptic.style.position = 'fixed';
				haptic.style.opacity = '0';
				haptic.style.pointerEvents = 'none';
				haptic.style.top = '-100px';
				document.body.appendChild(haptic);

				window.triggerIOSHaptic = function() {
					// Fallback for Android/Chrome
					if (navigator.vibrate) {
						navigator.vibrate(15);
					}
					// iOS WebKit Switch trigger
					const el = document.getElementById('iosHapticToggle');
					if (el) {
						el.click();
					}
				};
			})();
		""")

const lboard_name: String = "clicker_game_lboard"


var total_clicks: int = 0
var money_multiplier: int = 1
var new_money_multiplier: int = 0
#var prestige_weight: float = floor(log(total_clicks) / log(10))
var prestige_money_needed: int = 150
var prestige_progress: float = 0


var player_name: String = str("Player ", str(randi_range(1, 999)))
var username: String
var password: String

var save_name: String = "save_name"



func save_game():
	await Talo.current_player.set_prop("total_clicks", str(Global.total_clicks))
	print("total_clicks prop set to: ", Talo.current_player.get_prop("total_clicks"))
	
	await Talo.current_player.set_prop("money_multiplier", str(Global.money_multiplier))
	
	await Talo.current_player.set_prop("prestige_money_needed", str(Global.prestige_money_needed))
	
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
