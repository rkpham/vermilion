@tool
class_name ReconstructionComponent
extends Node3D

@export_category("References")
@export var reconstruction_shader: ShaderMaterial

@onready var mesh_instance = $MeshInstance3D
@onready var mesh_gpu_particle = $MeshInstance3D/GPUParticles3D
@onready var line_gpu_particle = $GPUParticles3D
@onready var original_obj = get_parent()

@onready var original_pos = original_obj.global_position

var reconstructed: bool = false

func _init():
	if not Engine.is_editor_hint():
		top_level = true

func _ready():
	var original_mesh_instance = original_obj.find_child("MeshInstance3D", false, false)
	mesh_instance.mesh = original_mesh_instance.mesh
	mesh_instance.set_surface_override_material(0, reconstruction_shader)
	line_gpu_particle.process_material.emission_shape_offset = to_local(original_pos)
	line_gpu_particle.process_material.direction = global_position - original_pos
	mesh_gpu_particle.process_material.set_emission_shape_scale(mesh_instance.mesh.get_aabb().size)
	if Engine.is_editor_hint():
		mesh_instance.show()

func _process(delta): 
	if not Engine.is_editor_hint():
		var dist = (Game.player.global_position - global_position).length() - 5.0
		dist = clampf(dist, 0.0, 1000.0)
		dist = sqrt(dist)
		dist = clampf(dist, 0.01, 2.0)
		reconstruction_shader.set_shader_parameter("stability", dist)
		original_pos = original_obj.global_position
		line_gpu_particle.process_material.emission_shape_offset = to_local(original_pos)
		line_gpu_particle.process_material.direction = to_local(line_gpu_particle.global_position) - to_local(original_pos)

func interact():
	reconstructed = not reconstructed
	if Game.active_item != Game.ItemType.RECONSTRUCTOR:
		return
	if reconstructed:
		reconstruct()
	else:
		deconstruct()

func reconstruct():
	visible = true
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(line_gpu_particle, "transparency", 0.0, 0.3)
	tween.tween_property(mesh_gpu_particle, "transparency", 0.0, 0.3)
	tween.tween_method(set_shader_opacity, 0.0, 1.0, 0.3)
	await tween.finished
	
	
func deconstruct():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(line_gpu_particle, "transparency", 1.0, 0.3)
	tween.tween_property(mesh_gpu_particle, "transparency", 1.0, 0.3)
	tween.tween_method(set_shader_opacity, 1.0, 0.0, 0.3)
	await tween.finished
	visible = false
	
func set_shader_opacity(opacity: float) -> void:
	reconstruction_shader.set_shader_parameter("opacity", opacity)
