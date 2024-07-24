class_name CloseUpComponent
extends Node3D

var interacting: bool = false

@onready var cam = $Camera3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if interacting:
			interacting = false
			Game.player.cam.cam_copy = null
			Game.player.frozen = false
			Game.viewmodel.frozen = false

func interact() -> void:
	if not interacting:
		interacting = true
		Game.player.frozen = true
		Game.player.cam.cam_copy = cam
		Game.viewmodel.frozen = true
		Game.player.footsteps.stepping = false
