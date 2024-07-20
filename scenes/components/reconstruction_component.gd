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

func _init():
	if not Engine.is_editor_hint():
		top_level = true

func _ready():
	var original_mesh_instance = get_parent().find_child("MeshInstance3D", false, false)
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

func reconstruct():
	mesh_instance.show()
	
func deconstruct():
	mesh_instance.hide()
