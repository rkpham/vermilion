class_name Interactable
extends CollisionObject3D

@export var collision: CollisionShape3D 
@export var mesh_node: Node3D

var mesh: MeshInstance3D
var material: StandardMaterial3D

func _ready():
	if not mesh_node:
		return
	for child in mesh_node.get_children():
			if child is MeshInstance3D:
				mesh = child
				material = child.get_surface_override_material(0)
				break

func interact():
	for child in get_children():
		if child.has_method("interact"):
			child.interact()
