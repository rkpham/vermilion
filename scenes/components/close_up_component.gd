class_name CloseUpComponent
extends Node3D

var interacting: bool = false
var focused_puzzle_item: int = 0:
	set = _set_focused_puzzle_item

@export var puzzle_items: Array[PuzzleItem] = []

@onready var cam = $Camera3D

func _input(event: InputEvent) -> void:
	if interacting:
		if event.is_action_pressed("ui_cancel"):
			interacting = false
			Game.player.cam.cam_copy = null
			Game.player.frozen = false
			Game.viewmodel.frozen = false
			Game.ui.interact_icons.visible = true
		if event.is_action_pressed("move_left"):
			if focused_puzzle_item > 0:
				focused_puzzle_item -= 1
		if event.is_action_pressed("move_right"):
			if focused_puzzle_item < puzzle_items.size() - 1:
				focused_puzzle_item += 1


func interact() -> bool:
	if not interacting:
		focused_puzzle_item = 0
		interacting = true
		Game.player.frozen = true
		Game.player.cam.cam_copy = cam
		Game.viewmodel.frozen = true
		Game.player.footsteps.stepping = false
		Game.ui.interact_icons.visible = false
	return true


func _set_focused_puzzle_item(_num: int) -> void:
	if _num < 0 or _num >= puzzle_items.size():
		return
	
	puzzle_items[focused_puzzle_item].active = false
	focused_puzzle_item = _num
	puzzle_items[focused_puzzle_item].active = true
