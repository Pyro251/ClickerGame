extends Button

const BIG_BUTTON_SOUND = preload("res://Scenes/big_button_sound.tscn")
const SMALL_BUTTON_SOUND = preload("res://Scenes/small_button_sound.tscn")

@onready var title_label: Label = $TitleLabel
@onready var cost_label: Label = $CostLabel
@onready var owned_amount_label: Label = $OwnedAmountLabel
@onready var description_rich_text_label: RichTextLabel = $DescriptionRichTextLabel

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export var use_big_button_sound: bool = false
@export var use_small_button_sound: bool = false

@export var cost: int = 0
@export var cps: int = 0
@export var time: float = 0.0
@export var title: String

@export_multiline var custom_description: String = ""


func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	button_down.connect(_button_pressed)
	Global.refresh_theme.connect(refresh_theme)
	refresh_theme()
	
	title_label.text = title
	cost_label.text = str(cost, "$")
	if !custom_description == "":
		description_rich_text_label.text = custom_description
	else:
		description_rich_text_label.text = str("+ ", cps, " Clicks Per Second")
	
	if !Global.owned_items.has(title):
		Global.owned_items.get_or_add(title, 1)
	else:
		Global.owned_items[title] += 1
	
	
	owned_amount_label.text = str("Owned: ", Global.owned_items[title])

func refresh_theme():
	# Setting the button style according to the equipped theme
	
	var normal_style: StyleBoxFlat = StyleBoxFlat.new()
	
	normal_style.bg_color = Global.button_color
	
	normal_style.corner_radius_bottom_left = 25
	normal_style.corner_radius_bottom_right = 25
	normal_style.corner_radius_top_left = 25
	normal_style.corner_radius_top_right = 25
	
	normal_style.shadow_size = 7
	
	add_theme_stylebox_override("normal", normal_style)
	
	
	var hover_style: StyleBoxFlat = StyleBoxFlat.new()
	
	hover_style.bg_color = Global.button_color
	
	hover_style.corner_radius_bottom_left = 25
	hover_style.corner_radius_bottom_right = 25
	hover_style.corner_radius_top_left = 25
	hover_style.corner_radius_top_right = 25
	
	hover_style.shadow_size = 20
	
	add_theme_stylebox_override("hover", hover_style)
	
	
	var pressed_style: StyleBoxFlat = StyleBoxFlat.new()
	
	pressed_style.bg_color = Global.button_color
	
	pressed_style.corner_radius_bottom_left = 25
	pressed_style.corner_radius_bottom_right = 25
	pressed_style.corner_radius_top_left = 25
	pressed_style.corner_radius_top_right = 25
	
	pressed_style.shadow_size = 0
	
	add_theme_stylebox_override("pressed", pressed_style)

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
	
	if Global.total_clicks >= cost:
		Global.total_clicks -= cost
		Global.clicks_per_second += cps
		if !Global.owned_items.has(title):
			Global.owned_items.get_or_add(title, 1)
		else:
			Global.owned_items[title] += 1
		
		owned_amount_label.text = str("Owned: ", Global.owned_items[title])
	
	if use_big_button_sound:
		var new_big_button_sound = BIG_BUTTON_SOUND.instantiate()
		#new_big_button_sound.play()
		add_child(new_big_button_sound)
	elif use_small_button_sound:
		var new_small_button_sound = SMALL_BUTTON_SOUND.instantiate()
		#new_small_button_sound.play()
		add_child(new_small_button_sound)
