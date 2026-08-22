extends Button

@onready var title_label: Label = $TitleLabel
@onready var cost_label: Label = $CostLabel
@onready var description_rich_text_label: RichTextLabel = $DescriptionRichTextLabel

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export var cost: int = 0
@export var title: String = "Title"

@export_multiline var description: String = "No description yet."


func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	button_down.connect(_button_pressed)
	
	
	title_label.text = title
	cost_label.text = str(cost, "$")
	description_rich_text_label.text = description


func _init_pivot():
	pivot_offset = size/2.0

func _button_enter():
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)

func _button_exit():
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func _button_pressed():
	var button_press_tween: Tween = create_tween()
	button_press_tween.tween_property(self, "scale", pressed_scale, 0.06).set_trans(Tween.TRANS_SINE)
	button_press_tween.tween_property(self, "scale", hover_scale, 0.12).set_trans(Tween.TRANS_SINE)
