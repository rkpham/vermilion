class_name PuzzleItem
extends Node3D

var focused: bool = false:
	set = _set_focused

@onready var indicator = $Indicator


func _set_focused(_focused: bool) -> void:
	focused = _focused
	indicator.visible = focused
