@tool
class_name SafeButton
extends Node3D

@onready var label: Label3D = $Label3D

@export_range(0, 9, 1) var number: int = 1
@export var submit_button: bool = false
@export var clear_button: bool = false
@export var additional_text: String = ""

signal number_pressed(number: int, submit: bool, clear: bool)

func _ready():
	if submit_button:
		label.text = "#"
	elif clear_button:
		label.text = "C"
	else:
		label.text = "%d" % number
		label.text += "\n%s" % additional_text


func _on_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		number_pressed.emit(number, submit_button, clear_button)

func _on_mouse_entered():
	label.modulate = Color(0.0, 1.0, 0.0)

func _on_mouse_exited():
	label.modulate = Color(1.0, 1.0, 1.0)
