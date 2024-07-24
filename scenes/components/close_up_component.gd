class_name CloseUpComponent
extends Node3D

@onready var cam = $Camera3D

func interact() -> void:
	Game.player.cam_copy = cam
