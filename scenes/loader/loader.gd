extends Node3D

signal finished_shaders
signal finished_models
signal finished

var shader_idx: int = 0
var model_idx: int = 0
var progress: float = 0.0
var shaders_loaded: bool = false
var models_loaded: bool = false

@export var shaders: Array[Material] = []
@export var models: Array[PackedScene] = []
@onready var quad = $Quad

func _process(delta: float) -> void:
	if not shaders_loaded:
		if shader_idx < shaders.size():
			quad.set_surface_override_material(0, shaders[shader_idx])
			shader_idx += 1
		else:
			shaders_loaded = true
			finished_shaders.emit()
	if not models_loaded:
		if model_idx < shaders.size():
			var new_model = models[model_idx].instantiate()
			quad.add_child(new_model)
			new_model.queue_free()
			model_idx += 1
		else:
			models_loaded = true
			finished_models.emit()
	progress = float(shader_idx + model_idx) / (shaders.size() + models.size() - 2)
	if shaders_loaded and models_loaded:
		print("sfds")
		finished.emit()
