extends Node3D

var shader_idx: int = 0

@export var shaders: Array[Material] = []

@onready var quad = $Quad

func _process(delta: float) -> void:
	if shader_idx < shaders.size():
		quad.set_surface_override_material(0, shaders[shader_idx])
		shader_idx += 1
	else:
		queue_free()
