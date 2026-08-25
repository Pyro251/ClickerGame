extends Button

const BIG_BUTTON_SOUND = preload("res://Scenes/big_button_sound.tscn")
const SMALL_BUTTON_SOUND = preload("res://Scenes/small_button_sound.tscn")

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export var use_big_button_sound: bool = false
@export var use_small_button_sound: bool = false

func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	button_down.connect(_button_pressed)
	
	call_deferred("_init_pivot")

func _init_pivot():
	pivot_offset = size/2.0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.triggerIOSHaptic();")

func _fire_haptic() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.triggerIOSHaptic();")

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
