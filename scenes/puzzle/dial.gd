class_name Dial
extends PuzzleItem

var number: int = 0:
	set = _set_number

@onready var dial_model = $Dial


func _input(event: InputEvent) -> void:
	if focused:
		if event.is_action_pressed("move_forward"):
			number -= 1
			number = wrapi(number, 0, 10)
		if event.is_action_pressed("move_back"):
			number += 1
			number = wrapi(number, 0, 10)


func _process(delta: float) -> void:
	dial_model.rotation.x = lerp_angle(dial_model.rotation.x, deg_to_rad(number * -36), delta * 16.0)


func _set_number(_number: int) -> void:
	number = _number
