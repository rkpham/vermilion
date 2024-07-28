extends Node

const WORLD = preload("res://scenes/world.tscn")

@onready var shader_loader = $ShaderLoader

func _ready() -> void:
	await shader_loader.finished
	shader_loader.queue_free()
	var world = WORLD.instantiate()
	add_child(world)

func _process(delta: float) -> void:
	if is_instance_valid(shader_loader):
		Game.ui.set_loading_progress(shader_loader.progress)
