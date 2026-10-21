extends Panel

var expanded: bool = false

@export var version: String
@export_multiline var version_description: String

func _ready() -> void:
	%ButtonExpandOrCompress.pressed.connect(expand_or_compress)
	
	%LabelVersion.text = version
	%VersionDescription.text = version_description

func expand_or_compress():
	if expanded:
		%AnimationPlayer.play("up")
	else:
		%AnimationPlayer.play("down")
	
	expanded = !expanded
