extends Node3D

signal finished

var shader_idx: int = 0
var progress: float = 0.0

@export var shaders: Array[Material] = []
@onready var quad = $Quad

func _process(delta: float) -> void:
	if shader_idx < shaders.size():
		quad.set_surface_override_material(0, shaders[shader_idx])
		progress = float(shader_idx) / (shaders.size() - 1)
		shader_idx += 1
	else:
		finished.emit()
