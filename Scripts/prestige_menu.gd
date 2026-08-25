extends Control

@onready var current_money_label: Label = $VBoxContainer/CurrentMoneyLabel
@onready var money_needed_label: Label = $VBoxContainer/MoneyNeededLabel
@onready var new_money_multiplier_label: Label = $VBoxContainer/NewMoneyMultiplierLabel
@onready var too_poor_label: Label = $TooPoorLabel

@onready var confirm_button: Button = $BottomBackground/ConfirmButton

func _ready() -> void:
	#print("Current prestige weight: ", Global.prestige_weight)
	#current_money_label.text = str(Global.total_clicks)
	#previous_money_multiplier_label.text = str(Global.money_multiplier)
	new_money_multiplier_label.text = str(Global.money_multiplier, "x -> ", Global.new_money_multiplier, "x")
	
	current_money_label.text = str(Global.total_clicks, "$")
	money_needed_label.text = str(Global.prestige_money_needed)
	
	if Global.total_clicks >= Global.prestige_money_needed:
		confirm_button.disabled = false
		too_poor_label.hide()
	else:
		confirm_button.disabled = true
		too_poor_label.show()



func _on_confirm_button_pressed() -> void:
	Global.money_multiplier = Global.new_money_multiplier
	Global.total_clicks = 0
	Global.prestige_money_needed *= 1.5
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
