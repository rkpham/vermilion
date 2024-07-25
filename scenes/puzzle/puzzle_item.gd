class_name PuzzleItem
extends Node3D

var active: bool = false:
	set = _set_active

@onready var indicator = $Indicator


func _set_active(_active: bool) -> void:
	active = _active
	indicator.visible = active
