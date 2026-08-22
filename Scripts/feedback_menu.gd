extends Control

@onready var text_edit: TextEdit = $FeedbackPanel/MarginContainer/VBoxContainer/TextEdit

var internal_name: String = "feedback"
var feedback_text: String




func _on_text_edit_text_changed() -> void:
	feedback_text = text_edit.text


func _on_submit_feedback_button_pressed() -> void:
	await Talo.feedback.send(internal_name, feedback_text)
	print("Feedback sent for %s: %s" % [internal_name, feedback_text])
	feedback_text = ""
	text_edit.text = ""
