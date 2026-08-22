extends Node2D

@onready var amount_label: Label = $SubViewport/AmountLabel
@onready var particles: GPUParticles2D = $GPUParticles2D

var clicks: int = 0


func _ready() -> void:
	amount_label.text = str(clicks)
	particles.emitting = true
