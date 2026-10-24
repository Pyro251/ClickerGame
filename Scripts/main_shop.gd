extends Control

@onready var money_label: Label = $TopBackground/MoneyLabel
@onready var grid_container: GridContainer = $ScrollContainer/MarginContainer/GridContainer
@onready var shop_element: Button = $ScrollContainer/MarginContainer/GridContainer/ShopElementTemplate2

var spacing: float = 50.0

func _ready() -> void:
	Global.show_shop_auto_clicker_detection.connect(func():
		%PanelAutoClickerDetected.show()
		%LabelStrikes.text = str(Global.auto_clicker_strikes, " Strikes left"))

func _process(delta: float) -> void:
	money_label.text = Global.simplify_number(Global.total_clicks)
	grid_container.columns = max(1, get_viewport_rect().size.x / (shop_element.size.x + spacing))
	#grid_container.columns = ceil(get_viewport_rect().size.x / shop_element.size.x)


func _on_prestige_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/prestige_menu.tscn")


func _on_theme_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/theme_shop.tscn")


func _on_button_accept_auto_clicker_warning_pressed() -> void:
	%PanelAutoClickerDetected.hide()
	if Global.auto_clicker_strikes <= 0:
		Global.auto_clicker_strikes = 3
