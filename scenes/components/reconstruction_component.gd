@tool
class_name ReconstructionComponent
extends Node3D

@export_category("References")
@export var reconstruction_shader: ShaderMaterial
@export var optional_model: Node3D

@onready var mesh_instance = $MeshInstance3D
@onready var mesh_gpu_particle = $MeshInstance3D/GPUParticles3D
@onready var original_obj = get_parent()

@onready var original_pos = original_obj.global_position

var reconstructed: bool = false

func _init():
	if not Engine.is_editor_hint():
		top_level = true

func _ready():
	if optional_model:
		var original_mesh_instance = find_mesh(optional_model)
		mesh_instance.mesh = original_mesh_instance.mesh
		mesh_instance.set_surface_override_material(0, reconstruction_shader)
	else:
		var original_mesh_instance = find_mesh(original_obj)
		mesh_instance.mesh = original_mesh_instance.mesh
		mesh_instance.set_surface_override_material(0, reconstruction_shader)
	mesh_gpu_particle.process_material.set_emission_shape_scale(mesh_instance.mesh.get_aabb().size)
	if Engine.is_editor_hint():
		mesh_instance.show()
		set_shader_opacity(1.0)
		mesh_gpu_particle.amount_ratio = 0.5
	else:
		set_shader_opacity(0.0)
		mesh_gpu_particle.amount_ratio = 0.0

func _process(delta): 
	if not Engine.is_editor_hint():
		var dist = (Game.player.global_position - global_position).length() - 5.0
		dist = clampf(dist, 0.0, 1000.0)
		dist = sqrt(dist)
		dist = clampf(dist, 0.01, 2.0)
		reconstruction_shader.set_shader_parameter("stability", dist)
		original_pos = original_obj.global_position

func interact() -> bool:
	reconstructed = not reconstructed
	if Game.active_item != Game.ItemType.RECONSTRUCTOR:
		return false
	if reconstructed:
		reconstruct()
	else:
		deconstruct()
	return true

func reconstruct():
	visible = true
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(mesh_gpu_particle, "amount_ratio", 0.5, 0.3)
	tween.tween_method(set_shader_opacity, 0.0, 1.0, 0.3)
	await tween.finished
	
	
func deconstruct():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(mesh_gpu_particle, "amount_ratio", 0.0, 0.3)
	tween.tween_method(set_shader_opacity, 1.0, 0.0, 0.3)
	await tween.finished
	visible = false
	
func set_shader_opacity(opacity: float) -> void:
	reconstruction_shader.set_shader_parameter("opacity", opacity)

func find_mesh(node: Node3D) -> MeshInstance3D:
	for child in optional_model.get_children():
			if child is MeshInstance3D:
				return child
	return null
