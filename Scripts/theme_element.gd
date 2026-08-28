extends Button

@onready var title_label: Label = $TitleLabel
@onready var cost_label: Label = $CostLabel

@onready var main_color_rect: ColorRect = $MainColorRect
@onready var accent_color_rect: ColorRect = $AccentColorRect
@onready var button_color_rect: ColorRect = $TextColorRect

const BIG_BUTTON_SOUND = preload("res://Scenes/big_button_sound.tscn")
const SMALL_BUTTON_SOUND = preload("res://Scenes/small_button_sound.tscn")

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export var use_big_button_sound: bool = false
@export var use_small_button_sound: bool = false

@export var title: String
@export var cost: int

@export_color_no_alpha var main_color: Color
@export_color_no_alpha var accent_color: Color
@export_color_no_alpha var button_color: Color

var owned: bool = false

func _ready() -> void:
	Global.refresh_theme.connect(refresh_theme)
	refresh_theme()
	
	title_label.text = title
	cost_label.text = str(cost)
	
	main_color_rect.color = main_color
	accent_color_rect.color = accent_color
	button_color_rect.color = button_color
	
	Global.update_selected_theme.connect(update_selected_theme)
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	button_down.connect(_button_pressed)
	
	if !Global.owned_themes.has(title):
		Global.owned_themes.get_or_add(title, false)
		owned = false
	else:
		owned = true
		unequip()
	
	if Global.owned_themes[title]:
		cost_label.hide()
	
	if Global.selected_theme.has(title):
		if Global.selected_theme[title] == true:
			equip()
		else:
			unequip()
	else:
		Global.selected_theme[title] = false
	
	
	Global.save_game()
	
	
	call_deferred("_init_pivot")

func update_selected_theme():
	
	Global.selected_theme[title] = false
	unequip()
	

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

func equip():
	$EquippedLabel.show()
	$EquipButton.hide()
	
	Global.main_color = main_color
	Global.accent_color = accent_color
	Global.button_color = button_color
	
	Global.selected_theme[title] = true
	
	Global.refresh_theme.emit()
	
	Global.save_game()
	
	print("Colors set to: \n Main:", Global.main_color, "\n Accent:", Global.accent_color, "\n Text:", Global.button_color)

func unequip():
	$EquippedLabel.hide()
	$EquipButton.show()
	
	Global.selected_theme[title] = false

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
	
	
	if use_big_button_sound:
		var new_big_button_sound = BIG_BUTTON_SOUND.instantiate()
		#new_big_button_sound.play()
		add_child(new_big_button_sound)
	elif use_small_button_sound:
		var new_small_button_sound = SMALL_BUTTON_SOUND.instantiate()
		#new_small_button_sound.play()
		add_child(new_small_button_sound)
		
	
	if Global.total_clicks >= cost:
		if !Global.owned_themes[title]:
			Global.total_clicks -= cost
		Global.update_selected_theme.emit()
		Global.selected_theme[title] = true
		cost_label.hide()
		equip()
		Global.save_game()


func _on_equip_button_pressed() -> void:
	Global.update_selected_theme.emit()
	equip()
