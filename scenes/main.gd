extends Node

const WORLD = preload("res://scenes/world.tscn")

@onready var shader_loader = $ShaderLoader

func _ready() -> void:
	await shader_loader.finished_shaders
	Game.ui.loading_text.text = "Loading models..."
	await shader_loader.finished_models
	Game.ui.loading_text.text = "Finished."
	await shader_loader.finished
	Game.ui.loading.hide()
	shader_loader.queue_free()
	var world = WORLD.instantiate()
	add_child(world)

func _process(delta: float) -> void:
	if is_instance_valid(shader_loader):
		Game.ui.set_loading_progress(shader_loader.progress)
