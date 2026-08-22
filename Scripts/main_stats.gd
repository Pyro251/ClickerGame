extends StatsAPI


func _ready() -> void:
	Global.update_clicks.connect(update_clicks)


func update_clicks():
	print("Updating Clicks......")
	var total_clicks := await Talo.stats.track("total_clicks", Global.total_clicks)
	print("Total Clicks: ", total_clicks.value)
	#var res := await Talo.stats.track("total_clicks_stat")
	#print("%s, %s" % [res.value, res.stat.global_value])
