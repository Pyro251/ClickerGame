extends Control

@onready var money_label: Label = $TopBackground/MoneyLabel

func _ready() -> void:
	Global.change_labels_font_color(self, Global.button_color)


func _process(delta: float) -> void:
	money_label.text = str(Global.total_clicks)
