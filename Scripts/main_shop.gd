extends Control

@onready var money_label: Label = $TopBackground/MoneyLabel
@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var shop_element: Button = $ScrollContainer/GridContainer/ShopElementTemplate2


func _process(delta: float) -> void:
	money_label.text = str(Global.total_clicks)
	grid_container.columns = ceil(get_viewport_rect().size.x / shop_element.size.x) - 2


func _on_prestige_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/prestige_menu.tscn")
