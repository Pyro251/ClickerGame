extends Control

@onready var current_money_label: Label = $VBoxContainer/CurrentMoneyLabel
@onready var previous_money_multiplier_label: Label = $VBoxContainer/PreviousMoneyMultiplierLabel
@onready var new_money_multiplier_label: Label = $VBoxContainer/NewMoneyMultiplierLabel


func _ready() -> void:
	print("Current prestige weight: ", Global.prestige_weight)
	current_money_label.text = str(Global.total_clicks)
	previous_money_multiplier_label.text = str(Global.money_multiplier)
	Global.new_money_multiplier_label.text = str(Global.new_money_multiplier)



func _on_confirm_button_pressed() -> void:
	Global.money_multiplier = Global.new_money_multiplier
	Global.total_clicks = 0
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
